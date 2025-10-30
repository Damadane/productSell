<template>
  <div class="product-list">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>商品列表</span>
          <div class="flex space-x-2">
            <el-input v-model="searchQuery" placeholder="搜索商品" style="width: 200px" />
            <el-button type="primary" @click="addProduct">添加商品</el-button>
          </div>
        </div>
      </template>
      
      <el-table :data="products" border style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="商品ID" width="80" />
        <el-table-column prop="name" label="商品名称" />
        <el-table-column prop="category" label="分类" width="120" />
        <el-table-column prop="price" label="价格" width="100">
          <template #default="{ row }">
            ¥{{ row.price }}
          </template>
        </el-table-column>
        <el-table-column prop="stock" label="库存" width="100" />
        <el-table-column prop="origin" label="产地" width="120" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="editProduct(row)">编辑</el-button>
            <el-button size="small" type="danger" @click="deleteProduct(row)">删除</el-button>
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

const products = ref([])

const fetchProducts = async () => {
  try {
    loading.value = true
    const { data, error, count } = await supabase
      .from('products_47212')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    products.value = data || []
    total.value = count || 0
  } catch (error) {
    ElMessage.error('获取商品列表失败: ' + error.message)
    console.error('Fetch products error:', error)
  } finally {
    loading.value = false
  }
}

const addProduct = () => {
  ElMessage.info('添加商品功能')
}

const editProduct = (product) => {
  ElMessage.info(`编辑商品: ${product.name}`)
}

const deleteProduct = async (product) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除商品 "${product.name}" 吗?`,
      '删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    const { error } = await supabase
      .from('products_47212')
      .delete()
      .eq('id', product.id)
    
    if (error) throw error
    
    ElMessage.success('删除成功')
    fetchProducts() // 重新获取数据
  } catch (error) {
    if (error.name !== 'Cancel') {
      ElMessage.error('删除失败: ' + error.message)
      console.error('Delete product error:', error)
    }
  }
}

const handlePageChange = (page) => {
  currentPage.value = page
  ElMessage.info(`跳转到第 ${page} 页`)
}

onMounted(() => {
  fetchProducts()
})
</script>
