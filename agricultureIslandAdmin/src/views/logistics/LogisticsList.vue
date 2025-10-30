<template>
  <div class="logistics-list">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>物流列表</span>
          <div class="flex space-x-2">
            <el-select v-model="statusFilter" placeholder="物流状态" style="width: 150px">
              <el-option label="全部" value="" />
              <el-option label="待发货" value="pending" />
              <el-option label="运输中" value="shipping" />
              <el-option label="已送达" value="delivered" />
              <el-option label="已签收" value="received" />
            </el-select>
            <el-input v-model="searchQuery" placeholder="搜索订单号" style="width: 200px" />
            <el-button type="primary" @click="searchLogistics">搜索</el-button>
          </div>
        </div>
      </template>
      
      <el-table :data="logistics" border style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="物流ID" width="120" />
        <el-table-column prop="carrier" label="物流公司" width="120" />
        <el-table-column prop="tracking_number" label="物流单号" width="150" />
        <el-table-column prop="status" label="物流状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">
              {{ getStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="创建时间" width="180" />
        <el-table-column label="操作" width="150">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="viewLogistics(row)">查看详情</el-button>
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
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { supabase } from '../../supabaseClient'

const statusFilter = ref('')
const searchQuery = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const loading = ref(false)

const logistics = ref([])

const fetchLogistics = async () => {
  try {
    loading.value = true
    let query = supabase
      .from('logistics_47212')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false })

    if (statusFilter.value) {
      query = query.eq('status', statusFilter.value)
    }

    const { data, error, count } = await query
    
    if (error) throw error
    
    logistics.value = data || []
    total.value = count || 0
  } catch (error) {
    ElMessage.error('获取物流信息失败: ' + error.message)
    console.error('Fetch logistics error:', error)
  } finally {
    loading.value = false
  }
}

const searchLogistics = () => {
  fetchLogistics()
}

const getStatusText = (status) => {
  const statusMap = {
    'pending': '待发货',
    'shipping': '运输中',
    'delivered': '已送达',
    'received': '已签收'
  }
  return statusMap[status] || status
}

const getStatusType = (status) => {
  const typeMap = {
    'pending': 'info',
    'shipping': 'warning',
    'delivered': 'primary',
    'received': 'success'
  }
  return typeMap[status] || 'info'
}

const viewLogistics = (logistic) => {
  ElMessage.info(`查看物流详情: ${logistic.tracking_number}`)
}

const handlePageChange = (page) => {
  currentPage.value = page
  fetchLogistics() // 切换页面时刷新数据
}

onMounted(() => {
  fetchLogistics()
})
</script>
