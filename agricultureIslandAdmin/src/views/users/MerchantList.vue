<template>
  <div class="merchant-list">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>商家管理</span>
          <div class="flex space-x-2">
            <el-input v-model="searchQuery" placeholder="搜索商家" style="width: 200px" />
            <el-button type="primary" @click="addMerchant">添加商家</el-button>
          </div>
        </div>
      </template>
      
      <el-table :data="merchants" border style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="商家ID" width="80" />
        <el-table-column prop="name" label="商家名称" width="150" />
        <el-table-column prop="phone" label="联系电话" width="120" />
        <el-table-column prop="email" label="邮箱" />
        <el-table-column prop="created_at" label="注册时间" width="180" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="viewMerchant(row)">查看详情</el-button>
            <el-button size="small" type="danger" @click="deleteMerchant(row)">删除</el-button>
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

const merchants = ref([])

const fetchMerchants = async () => {
  try {
    loading.value = true
    const { data, error, count } = await supabase
      .from('users_47212')
      .select('*', { count: 'exact' })
      .eq('role', 'merchant')
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    merchants.value = data || []
    total.value = count || 0
  } catch (error) {
    ElMessage.error('获取商家列表失败: ' + error.message)
    console.error('Fetch merchants error:', error)
  } finally {
    loading.value = false
  }
}

const addMerchant = () => {
  ElMessage.info('添加商家功能')
}

const viewMerchant = (merchant) => {
  ElMessage.info(`查看商家详情: ${merchant.name}`)
}

const deleteMerchant = async (merchant) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除商家 "${merchant.name}" 吗?`,
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
      .eq('id', merchant.id)
    
    if (error) throw error
    
    ElMessage.success('删除成功')
    fetchMerchants() // 重新获取数据
  } catch (error) {
    if (error.name !== 'Cancel') {
      ElMessage.error('删除失败: ' + error.message)
      console.error('Delete merchant error:', error)
    }
  }
}

const handlePageChange = (page) => {
  currentPage.value = page
  ElMessage.info(`跳转到第 ${page} 页`)
}

onMounted(() => {
  fetchMerchants()
})
</script>
