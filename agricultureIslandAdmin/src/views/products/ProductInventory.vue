<template>
  <div class="product-inventory">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>库存管理</span>
          <div class="flex space-x-2">
            <el-input v-model="searchQuery" placeholder="搜索商品" style="width: 200px" />
            <el-button type="primary">导出库存</el-button>
          </div>
        </div>
      </template>
      
      <el-table :data="inventory" border style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="商品ID" width="80" />
        <el-table-column prop="name" label="商品名称" />
        <el-table-column prop="category" label="分类" width="120" />
        <el-table-column prop="currentStock" label="当前库存" width="120" />
        <el-table-column prop="minStock" label="最低库存" width="120" />
        <el-table-column prop="status" label="库存状态" width="120">
          <template #default="{ row }">
            <el-tag :type="getStockStatusType(row)">
              {{ getStockStatus(row) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="adjustStock(row)">调整库存</el-button>
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

const searchQuery = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const loading = ref(false)

const inventory = ref([])

const fetchInventory = async () => {
  try {
    loading.value = true
    const { data, error, count } = await supabase
      .from('products_47212')
      .select('id, name, category, stock', { count: 'exact' })
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    inventory.value = (data || []).map(item => ({
      id: item.id,
      name: item.name,
      category: item.category,
      currentStock: item.stock || 0,
      minStock: 10 // 假设最低库存为10
    }))
    
    total.value = count || 0
  } catch (error) {
    ElMessage.error('获取库存信息失败: ' + error.message)
    console.error('Fetch inventory error:', error)
  } finally {
    loading.value = false
  }
}

const getStockStatus = (item) => {
  if (item.currentStock <= item.minStock) return '库存不足'
  if (item.currentStock <= item.minStock * 2) return '库存预警'
  return '库存充足'
}

const getStockStatusType = (item) => {
  const status = getStockStatus(item)
  if (status === '库存不足') return 'danger'
  if (status === '库存预警') return 'warning'
  return 'success'
}

const adjustStock = (item) => {
  ElMessage.info(`调整库存: ${item.name}`)
}

const handlePageChange = (page) => {
  currentPage.value = page
  ElMessage.info(`跳转到第 ${page} 页`)
}

onMounted(() => {
  fetchInventory()
})
</script>
