<template>
  <div class="order-list">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>订单列表</span>
          <div class="flex space-x-2">
            <el-select v-model="statusFilter" placeholder="订单状态" style="width: 150px">
              <el-option label="全部" value="" />
              <el-option label="待付款" value="pending" />
              <el-option label="待发货" value="paid" />
              <el-option label="已发货" value="shipped" />
              <el-option label="已完成" value="completed" />
            </el-select>
            <el-input v-model="searchQuery" placeholder="搜索订单号/客户" style="width: 200px" />
            <el-button type="primary" @click="searchOrders">搜索</el-button>
          </div>
        </div>
      </template>
      
      <el-table :data="orders" border style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="订单号" width="120" />
        <el-table-column prop="order_number" label="订单编号" width="120" />
        <el-table-column prop="total_amount" label="订单金额" width="100">
          <template #default="{ row }">
            ¥{{ row.total_amount }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">
              {{ getOrderStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="下单时间" width="180" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="viewOrder(row)">查看详情</el-button>
            <el-button v-if="row.status === 'paid'" size="small" type="success" @click="shipOrder(row)">发货</el-button>
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

const orders = ref([])

const fetchOrders = async () => {
  try {
    loading.value = true
    let query = supabase
      .from('orders_47212')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false })

    if (statusFilter.value) {
      query = query.eq('status', statusFilter.value)
    }

    const { data, error, count } = await query
    
    if (error) throw error
    
    orders.value = data || []
    total.value = count || 0
  } catch (error) {
    ElMessage.error('获取订单列表失败: ' + error.message)
    console.error('Fetch orders error:', error)
  } finally {
    loading.value = false
  }
}

const searchOrders = () => {
  fetchOrders()
}

const getOrderStatusText = (status) => {
  const statusMap = {
    'pending': '待付款',
    'paid': '待发货',
    'shipped': '已发货',
    'completed': '已完成',
    'cancelled': '已取消'
  }
  return statusMap[status] || status
}

const getStatusType = (status) => {
  const typeMap = {
    'pending': 'info',
    'paid': 'warning',
    'shipped': 'primary',
    'completed': 'success',
    'cancelled': 'danger'
  }
  return typeMap[status] || 'info'
}

const viewOrder = (order) => {
  ElMessage.info(`查看订单详情: ${order.order_number}`)
}

const shipOrder = async (order) => {
  try {
    const { error } = await supabase
      .from('orders_47212')
      .update({ status: 'shipped' })
      .eq('id', order.id)
    
    if (error) throw error
    
    ElMessage.success(`订单 ${order.order_number} 已发货`)
    fetchOrders() // 刷新列表
  } catch (error) {
    ElMessage.error('发货失败: ' + error.message)
    console.error('Ship order error:', error)
  }
}

const handlePageChange = (page) => {
  currentPage.value = page
  fetchOrders() // 切换页面时刷新数据
}

onMounted(() => {
  fetchOrders()
})
</script>
