<template>
  <div class="member-list">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>会员管理</span>
          <div class="flex space-x-2">
            <el-select v-model="levelFilter" placeholder="会员等级" style="width: 150px">
              <el-option label="全部" value="" />
              <el-option label="普通会员" value="regular" />
              <el-option label="银卡会员" value="silver" />
              <el-option label="金卡会员" value="gold" />
              <el-option label="钻石会员" value="diamond" />
            </el-select>
            <el-input v-model="searchQuery" placeholder="搜索会员" style="width: 200px" />
            <el-button type="primary">搜索</el-button>
          </div>
        </div>
      </template>
      
      <el-table :data="members" border style="width: 100%">
        <el-table-column prop="id" label="会员ID" width="100" />
        <el-table-column prop="name" label="姓名" width="120" />
        <el-table-column prop="phone" label="手机号" width="120" />
        <el-table-column prop="level" label="会员等级" width="100">
          <template #default="{ row }">
            <el-tag :type="getLevelType(row.level)">
              {{ getLevelText(row.level) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="points" label="积分" width="100" />
        <el-table-column prop="consumption" label="消费金额" width="120">
          <template #default="{ row }">
            ¥{{ row.consumption }}
          </template>
        </el-table-column>
        <el-table-column prop="registerTime" label="注册时间" width="180" />
        <el-table-column label="操作" width="150">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="viewMember(row)">查看详情</el-button>
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
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const levelFilter = ref('')
const searchQuery = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(325)

const members = ref([
  {
    id: 'VIP10001',
    name: '张三',
    phone: '13800138000',
    level: 'gold',
    points: 2560,
    consumption: 12560.50,
    registerTime: '2022-03-15 14:30:22'
  },
  {
    id: 'VIP10002',
    name: '李四',
    phone: '13900139000',
    level: 'silver',
    points: 890,
    consumption: 5230.80,
    registerTime: '2022-08-20 10:15:45'
  }
])

const getLevelText = (level) => {
  const levelMap = {
    'regular': '普通会员',
    'silver': '银卡会员',
    'gold': '金卡会员',
    'diamond': '钻石会员'
  }
  return levelMap[level] || level
}

const getLevelType = (level) => {
  const typeMap = {
    'regular': 'info',
    'silver': '',
    'gold': 'warning',
    'diamond': 'success'
  }
  return typeMap[level] || 'info'
}

const viewMember = (member) => {
  ElMessage.info(`查看会员详情: ${member.name}`)
}

const handlePageChange = (page) => {
  currentPage.value = page
  ElMessage.info(`跳转到第 ${page} 页`)
}
</script>
