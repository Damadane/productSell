<template>
  <div class="coupon-list">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>优惠券管理</span>
          <el-button type="primary" @click="addCoupon">添加优惠券</el-button>
        </div>
      </template>
      
      <el-table :data="coupons" border style="width: 100%">
        <el-table-column prop="id" label="优惠券ID" width="100" />
        <el-table-column prop="name" label="优惠券名称" />
        <el-table-column prop="type" label="类型" width="100">
          <template #default="{ row }">
            <el-tag :type="getTypeType(row.type)">
              {{ getTypeText(row.type) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="discount" label="优惠金额" width="120">
          <template #default="{ row }">
            <div v-if="row.type === 'amount'">¥{{ row.discount }}</div>
            <div v-else>{{ row.discount }}%</div>
          </template>
        </el-table-column>
        <el-table-column prop="minAmount" label="满减条件" width="120">
          <template #default="{ row }">
            满¥{{ row.minAmount }}可用
          </template>
        </el-table-column>
        <el-table-column prop="validityPeriod" label="有效期" width="200" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 'active' ? 'success' : 'info'">
              {{ row.status === 'active' ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="editCoupon(row)">编辑</el-button>
            <el-button size="small" type="danger" @click="deleteCoupon(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const coupons = ref([
  {
    id: 'C1001',
    name: '新用户专享券',
    type: 'amount',
    discount: 20,
    minAmount: 99,
    validityPeriod: '2023-05-01 至 2023-06-30',
    status: 'active'
  },
  {
    id: 'C1002',
    name: '节日大促券',
    type: 'percent',
    discount: 15,
    minAmount: 199,
    validityPeriod: '2023-05-20 至 2023-05-25',
    status: 'active'
  }
])

const getTypeText = (type) => {
  const typeMap = {
    'amount': '满减券',
    'percent': '折扣券'
  }
  return typeMap[type] || type
}

const getTypeType = (type) => {
  const typeMap = {
    'amount': 'warning',
    'percent': 'success'
  }
  return typeMap[type] || 'info'
}

const addCoupon = () => {
  ElMessage.info('添加优惠券功能')
}

const editCoupon = (coupon) => {
  ElMessage.info(`编辑优惠券: ${coupon.name}`)
}

const deleteCoupon = (coupon) => {
  ElMessageBox.confirm(
    `确定要删除优惠券 "${coupon.name}" 吗?`,
    '删除确认',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(() => {
    ElMessage.success('删除成功')
  }).catch(() => {
    ElMessage.info('已取消删除')
  })
}
</script>
