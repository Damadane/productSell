<template>
  <div class="delivery-list">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>配送员管理</span>
          <div class="flex space-x-2">
            <el-input v-model="searchQuery" placeholder="搜索配送员" style="width: 200px" />
            <el-button type="primary" @click="addDelivery">添加配送员</el-button>
          </div>
        </div>
      </template>
      
      <el-table :data="deliveries" border style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="配送员ID" width="100" />
        <el-table-column prop="name" label="姓名" width="120" />
        <el-table-column prop="phone" label="联系电话" width="120" />
        <el-table-column prop="created_at" label="注册时间" width="180" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="viewDelivery(row)">查看详情</el-button>
            <el-button size="small" type="danger" @click="deleteDelivery(row)">删除</el-button>
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
import { ElMessage, ElMessageBox } from 'element-plus'
import { supabase } from '../../supabaseClient'

const searchQuery = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const loading = ref(false)

const deliveries = ref([])

const fetchDeliveries = async () => {
  try {
    loading.value = true
    const { data, error, count } = await supabase
      .from('users_47212')
      .select('*', { count: 'exact' })
      .eq('role', 'delivery')
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    deliveries.value = data || []
    total.value = count || 0
  } catch (error) {
    ElMessage.error('获取配送员列表失败: ' + error.message)
    console.error('Fetch deliveries error:', error)
  } finally {
    loading.value = false
  }
}

const addDelivery = () => {
  ElMessage.info('添加配送员功能')
}

const viewDelivery = (delivery) => {
  ElMessage.info(`查看配送员详情: ${delivery.name}`)
}

const deleteDelivery = async (delivery) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除配送员 "${delivery.name}" 吗?`,
      '删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    const { error } = await supabase
      .from('users_47212')
      .delete()
      .eq('id', delivery.id)
    
    if (error) throw error
    
    ElMessage.success('删除成功')
    fetchDeliveries() // 重新获取数据
  } catch (error) {
    if (error.name !== 'Cancel') {
      ElMessage.error('删除失败: ' + error.message)
      console.error('Delete delivery error:', error)
    }
  }
}

const handlePageChange = (page) => {
  currentPage.value = page
  ElMessage.info(`跳转到第 ${page} 页`)
}

onMounted(() => {
  fetchDeliveries()
})
</script>
