<template>
  <div class="recommendation-list">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>商品推荐管理</span>
          <el-button type="primary" @click="addRecommendation">添加推荐</el-button>
        </div>
      </template>
      
      <el-tabs v-model="activeTab">
        <el-tab-pane label="热销推荐" name="hot">
          <el-table :data="hotRecommendations" border style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="productName" label="商品名称" />
            <el-table-column prop="sales" label="销量" width="120" />
            <el-table-column prop="recommendTime" label="推荐时间" width="180" />
            <el-table-column label="操作" width="150">
              <template #default="{ row }">
                <el-button size="small" type="primary" @click="editRecommendation(row)">编辑</el-button>
                <el-button size="small" type="danger" @click="removeRecommendation(row)">移除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        
        <el-tab-pane label="新品推荐" name="new">
          <el-table :data="newRecommendations" border style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="productName" label="商品名称" />
            <el-table-column prop="listingTime" label="上架时间" width="180" />
            <el-table-column label="操作" width="150">
              <template #default="{ row }">
                <el-button size="small" type="primary" @click="editRecommendation(row)">编辑</el-button>
                <el-button size="small" type="danger" @click="removeRecommendation(row)">移除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        
        <el-tab-pane label="个性化推荐" name="personalized">
          <el-table :data="personalizedRecommendations" border style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="strategyName" label="推荐策略" />
            <el-table-column prop="targetUsers" label="目标用户" />
            <el-table-column prop="recommendCount" label="推荐商品数" width="120" />
            <el-table-column label="操作" width="200">
              <template #default="{ row }">
                <el-button size="small" type="primary" @click="editRecommendation(row)">编辑</el-button>
                <el-button size="small" type="success" @click="viewRecommendation(row)">查看详情</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const activeTab = ref('hot')

const hotRecommendations = ref([
  {
    id: 1,
    productName: '有机红富士苹果',
    sales: 1250,
    recommendTime: '2023-05-15 10:00:00'
  }
])

const newRecommendations = ref([
  {
    id: 1,
    productName: '绿色有机黄瓜',
    listingTime: '2023-05-10 09:00:00'
  }
])

const personalizedRecommendations = ref([
  {
    id: 1,
    strategyName: '高消费用户推荐',
    targetUsers: '消费金额>5000的用户',
    recommendCount: 25
  }
])

const addRecommendation = () => {
  ElMessage.info('添加推荐功能')
}

const editRecommendation = (recommendation) => {
  ElMessage.info(`编辑推荐: ${recommendation.productName || recommendation.strategyName}`)
}

const removeRecommendation = (recommendation) => {
  ElMessageBox.confirm(
    `确定要移除推荐 "${recommendation.productName || recommendation.strategyName}" 吗?`,
    '移除确认',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(() => {
    ElMessage.success('移除成功')
  }).catch(() => {
    ElMessage.info('已取消移除')
  })
}

const viewRecommendation = (recommendation) => {
  ElMessage.info(`查看推荐详情: ${recommendation.strategyName}`)
}
</script>
