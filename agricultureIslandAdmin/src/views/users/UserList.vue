<template>
  <div class="user-list">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>客户管理</span>
          <div class="flex space-x-2">
            <el-input v-model="searchQuery" placeholder="搜索客户" style="width: 200px" />
            <el-button type="primary" @click="addUser">添加客户</el-button>
          </div>
        </div>
      </template>
      
      <el-table :data="users" border style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="用户ID" width="80" />
        <el-table-column prop="name" label="姓名" width="120" />
        <el-table-column prop="phone" label="手机号" width="120" />
        <el-table-column prop="email" label="邮箱" />
        <el-table-column prop="created_at" label="注册时间" width="180" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="viewUser(row)">查看详情</el-button>
            <el-button size="small" type="danger" @click="deleteUser(row)">删除</el-button>
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

const users = ref([])

const fetchUsers = async () => {
  try {
    loading.value = true
    const { data, error, count } = await supabase
      .from('users_47212')
      .select('*', { count: 'exact' })
      .eq('role', 'customer')
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    users.value = data || []
    total.value = count || 0
  } catch (error) {
    ElMessage.error('获取用户列表失败: ' + error.message)
    console.error('Fetch users error:', error)
  } finally {
    loading.value = false
  }
}

const addUser = () => {
  ElMessage.info('添加客户功能')
}

const viewUser = (user) => {
  ElMessage.info(`查看客户详情: ${user.name}`)
}

const deleteUser = async (user) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除用户 "${user.name}" 吗?`,
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
      .eq('id', user.id)
    
    if (error) throw error
    
    ElMessage.success('删除成功')
    fetchUsers() // 重新获取数据
  } catch (error) {
    if (error.name !== 'Cancel') {
      ElMessage.error('删除失败: ' + error.message)
      console.error('Delete user error:', error)
    }
  }
}

const handlePageChange = (page) => {
  currentPage.value = page
  ElMessage.info(`跳转到第 ${page} 页`)
}

onMounted(() => {
  fetchUsers()
})
</script>
