<template>
  <div class="product-categories">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>商品分类管理</span>
          <el-button type="primary" @click="addCategory">添加分类</el-button>
        </div>
      </template>
      
      <el-table :data="categories" border style="width: 100%">
        <el-table-column prop="id" label="分类ID" width="80" />
        <el-table-column prop="name" label="分类名称" />
        <el-table-column prop="description" label="描述" />
        <el-table-column prop="productCount" label="商品数量" width="120" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="editCategory(row)">编辑</el-button>
            <el-button size="small" type="danger" @click="deleteCategory(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const categories = ref([
  { id: 1, name: '水果', description: '各类新鲜水果', productCount: 25 },
  { id: 2, name: '蔬菜', description: '有机绿色蔬菜', productCount: 42 },
  { id: 3, name: '肉类', description: '新鲜优质肉类', productCount: 18 },
  { id: 4, name: '蛋类', description: '营养丰富蛋品', productCount: 12 }
])

const addCategory = () => {
  ElMessage.info('添加分类功能')
}

const editCategory = (category) => {
  ElMessage.info(`编辑分类: ${category.name}`)
}

const deleteCategory = (category) => {
  ElMessageBox.confirm(
    `确定要删除分类 "${category.name}" 吗?`,
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
