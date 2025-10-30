<template>
  <div class="promotion-list">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>促销活动管理</span>
          <el-button type="primary" @click="addPromotion">添加促销活动</el-button>
        </div>
      </template>
      
      <el-table :data="promotions" border style="width: 100%">
        <el-table-column prop="id" label="活动ID" width="100" />
        <el-table-column prop="name" label="活动名称" />
        <el-table-column prop="type" label="活动类型" width="120">
          <template #default="{ row }">
            <el-tag :type="getTypeType(row.type)">
              {{ getTypeText(row.type) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="discount" label="优惠内容" width="150">
          <template #default="{ row }">
            <div v-if="row.type === 'amount'">满减: ¥{{ row.discount }}</div>
            <div v-else-if="row.type === 'percent'">折扣: {{ row.discount }}%</div>
            <div v-else-if="row.type === 'gift'">赠品: {{ row.giftName }}</div>
          </template>
        </el-table-column>
        <el-table-column prop="timeRange" label="活动时间" width="200" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">
              {{ getStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="editPromotion(row)">编辑</el-button>
            <el-button size="small" :type="row.status === 'active' ? 'info' : 'success'" @click="togglePromotion(row)">
              {{ row.status === 'active' ? '暂停' : '启用' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const promotions = ref([
  {
    id: 'P1001',
    name: '520浪漫大促',
    type: 'percent',
    discount: 20,
    timeRange: '2023-05-20 00:00 至 2023-05-20 23:59',
    status: 'active'
  },
  {
    id: 'P1002',
    name: '新品首发优惠',
    type: 'amount',
    discount: 50,
    minAmount: 299,
    timeRange: '2023-05-01 00:00 至 2023-05-31 23:59',
    status: 'active'
  }
])

const getTypeText = (type) => {
  const typeMap = {
    'amount': '满减活动',
    'percent': '折扣活动',
    'gift': '赠品活动'
  }
  return typeMap[type] || type
}

const getTypeType = (type) => {
  const typeMap = {
    'amount': 'warning',
    'percent': 'success',
    'gift': 'primary'
  }
  return typeMap[type] || 'info'
}

const getStatusText = (status) => {
  const statusMap = {
    'active': '进行中',
    'pending': '未开始',
    'expired': '已结束',
    'paused': '已暂停'
  }
  return statusMap[status] || status
}

const getStatusType = (status) => {
  const typeMap = {
    'active': 'success',
    'pending': 'info',
    'expired': 'danger',
    'paused': 'warning'
  }
  return typeMap[status] || 'info'
}

const addPromotion = () => {
  ElMessage.info('添加促销活动功能')
}

const editPromotion = (promotion) => {
  ElMessage.info(`编辑促销活动: ${promotion.name}`)
}

const togglePromotion = (promotion) => {
  const actionText = promotion.status === 'active' ? '暂停' : '启用'
  ElMessage.success(`已${actionText}促销活动: ${promotion.name}`)
}
</script>
