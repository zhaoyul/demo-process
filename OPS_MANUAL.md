# 红创科技多物理场仿真平台 — 运维手册

> 版本: V1.0 | 日期: 2026-05 | 招标条款: §10

---

## 一、部署架构

```
┌──────────────────────────────────────────────┐
│              负载均衡 / API Gateway           │
├──────────────────────────────────────────────┤
│  计算节点 1  │  计算节点 2  │  ...  │  N     │
│  MOOSE+MPI  │  MOOSE+MPI  │       │        │
├──────────────────────────────────────────────┤
│         共享存储 (NFS / Lustre)               │
│  /data/inputs  /data/outputs  /data/checkpoint│
├──────────────────────────────────────────────┤
│   conda 环境  │  MOOSE  │  Gmsh  │  ParaView  │
└──────────────────────────────────────────────┘
```

## 二、集群部署

### 环境要求

| 组件 | 最低 | 推荐 |
|------|------|------|
| OS | Linux x86_64 | Ubuntu 22.04+ / RHEL 9+ |
| CPU | 64 核 | ≥128 核 (2×EPYC 7K62) |
| 内存 | 256 GB | ≥512 GB DDR4 ECC |
| 存储 (热) | 1 TB NVMe | ≥7.6 TB NVMe RAID10 |
| 存储 (冷) | 8 TB HDD | ≥24 TB HDD RAID5 |
| 网络 | 10 GbE | InfiniBand HDR100 |

### 安装步骤

```bash
# 1. 在每个节点安装 conda 环境
bash scripts/deploy_env.sh

# 2. 编译 MOOSE (可在登录节点编译, 共享到计算节点)
cd /opt/moose
METHOD=opt make -j64

# 3. 配置 MPI
# /etc/mpi.conf
MPI_DEFAULT=mpich
MPI_HOSTFILE=/etc/mpi_hosts

# 4. 配置共享存储
mount -t nfs storage:/data /data

# 5. 验证
mpiexec -n 128 -f /etc/mpi_hosts hongchuang-opt -i test.i
```

## 三、检查点与恢复

### 配置检查点

在 `.i` 文件中:
```
[Outputs]
  [checkpoint]
    type = Checkpoint
    num_files = 2
    time_step_interval = 100
  []
[]
```

### 从检查点恢复

```bash
hongchuang-opt -i input.i --recover /path/to/checkpoint_cp/LATEST
```

### 验证恢复一致性

```bash
# 1. 完整计算
mpiexec -n 128 hongchuang-opt -i benchmark.i

# 2. 从检查点恢复 (中途)
mpiexec -n 128 hongchuang-opt -i benchmark.i --recover checkpoint_cp/0100-restart-0.rd

# 3. 对比结果 (范数误差应 < 1e-10)
python3 scripts/compare_results.py full_out.e recovered_out.e
```

## 四、监控与告警

### 健康检查

```bash
# 节点健康
pdsh -w node[1-32] 'nvidia-smi; free -h; df -h /data'

# MOOSE 进程健康
ps aux | grep hongchuang | wc -l

# 作业队列
squeue -u hongchuang
```

### 性能监控

```bash
# 实时 CPU/内存
htop

# MPI 通信统计
export MPICH_MPIIO_STATS=1
mpiexec -n 128 hongchuang-opt -i benchmark.i

# I/O 吞吐
iostat -x 1
```

### 告警阈值

| 指标 | 警告 | 严重 |
|------|------|------|
| CPU 使用率 | >90% 持续 5min | >95% |
| 内存使用率 | >80% | >95% |
| 磁盘使用率 | >80% | >95% |
| 作业排队时间 | >1h | >4h |

## 五、备份与恢复

### 数据备份

```bash
# 每日增量备份
rsync -avz --delete /data/outputs/ backup:/backup/outputs/

# 每周全量备份
tar -czf /backup/weekly-$(date +%Y%m%d).tar.gz /data/

# 检查点备份
rsync -avz /data/checkpoints/ backup:/backup/checkpoints/
```

### RTO/RPO

| 级别 | RPO | RTO |
|------|-----|-----|
| 计算任务 | 最后检查点 | 5 min |
| 输出数据 | 每日备份 | 30 min |
| 系统 | 每周全量 | 4 h |

## 六、安全

### 访问控制

```bash
# RBAC 用户管理
groupadd hongchuang_users
useradd -G hongchuang_users researcher1

# 文件权限
chmod 750 /data
chown root:hongchuang_users /data

# SSH 密钥认证
# /etc/ssh/sshd_config
PasswordAuthentication no
PubkeyAuthentication yes
```

### 审计日志

```bash
# 启用审计
auditctl -w /data/ -p rwxa -k hongchuang_data

# 查看日志
ausearch -k hongchuang_data --start today
```

## 七、故障排除

| 问题 | 诊断 | 解决 |
|------|------|------|
| MPI 启动失败 | `mpiexec --version` | 检查 MPI 环境变量 |
| 内存不足 | `free -h`, OOM killer 日志 | 增加节点或减小编程 |
| 磁盘满 | `df -h /data` | 清理旧输出, 扩展存储 |
| 检查点损坏 | `ncdump checkpoint_cp/*.rd` | 使用更早的检查点 |
| PETSc 错误 | 错误日志 | 检查 `-ksp_monitor -ksp_converged_reason` |
