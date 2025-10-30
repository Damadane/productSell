<template>
  <div class="order-refund">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>退货管理</span>
          <div class="flex space-x-2">
            <el-select v-model="statusFilter" placeholder="退货状态" style="width: 150px">
              <el-option label="全部" value="" />
              <el-option label="待处理" value="pending" />
              <el-option label="已同意" value="approved" />
              <el-option label="已拒绝" value="rejected" />
              <el-option label="已完成" value="completed" />
            </el-select>
            <el-input v-model="searchQuery" placeholder="搜索订单号" style="width: 200px" />
            <el-button type="primary">搜索</el-button>
          </div>
        </div>
      </template>
      
      <el-table :data="refunds" border style="width: 100%">
        <el-table-column prop="id" label="退货单号" width="120" />
        <el-table-column prop="orderId" label="关联订单" width="120" />
        <el-table-column prop="customer" label="客户" width="120" />
        <el-table-column prop="amount" label="退款金额" width="100">
          <template #default="{ row }">
            ¥{{ row.amount }}
          </template>
        </el-table-column>
        <el-table-column prop="reason" label="退货原因" />
        <el-table-column prop="applyTime" label="申请时间" width="180" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">
              {{ getRefundStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="viewRefund(row)">查看详情</el-button>
            <el-button v-if="row.status === 'pending'" size="small" type="success" @click="processRefund(row, 'approved')">同意</el-button>
            <el-button v-if="row.status === 'pending'" size="small" type="danger" @click="processRefund(row, 'rejected')">拒绝</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="mt-4 flex justify-end">
        <el-pagination
          :current-page="currentPage"
          :page-size="pageSize"
          :total="total"
          layout="prev, pager, next"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const statusFilter = ref('')
const searchQuery = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(25)

const refunds = ref([
  {
    id: 'T20230001',
    orderId: '20230001',
    customer: '张三',
    amount: 298.00,
    reason: '商品破损',
    applyTime: '2023-05-15 16:30:22',
    status: 'pending'
  },
  {
    id: 'T20230002',
    orderId: '20230005',
    customer: '李四',
    amount: 125.50,
    reason: '不喜欢',
    applyTime: '2023-05-14 14:15:45',
    status: 'approved'
  }
])

const getRefundStatusText = (status) => {
  const statusMap = {
    'pending': '待处理',
    'approved': '已同意',
    'rejected': '已拒绝',
    'completed': '已完成'
  }
  return statusMap[status] || status
}

const getStatusType = (status) => {
  const typeMap = {
    'pending': 'warning',
    'approved': 'primary',
    'rejected': 'danger',
    'completed': 'success'
  }
  return typeMap[status] || 'info'
}

const viewRefund = (refund) => {
  ElMessage.info(`查看退货详情: ${refund.id}`)
}

const processRefund = (refund, action) => {
  const actionText = action === 'approved' ? '同意' : '拒绝'
  ElMessage.success(`已${actionText}退货申请: ${refund.id}`)
}

const handlePageChange = (page) => {
  currentPage.value = page
  ElMessage.info(`跳转到第 ${page} 页`)
}
</script>
