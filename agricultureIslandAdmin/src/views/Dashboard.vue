<template>
  <div class="dashboard">
    <el-row :gutter="20" class="mb-6">
      <el-col :span="6">
        <el-card class="text-center">
          <div class="text-3xl font-bold text-blue-600">128</div>
          <div class="text-gray-500 mt-2">今日订单</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="text-center">
          <div class="text-3xl font-bold text-green-600">56</div>
          <div class="text-gray-500 mt-2">待发货</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="text-center">
          <div class="text-3xl font-bold text-yellow-600">23</div>
          <div class="text-gray-500 mt-2">待处理</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="text-center">
          <div class="text-3xl font-bold text-red-600">5</div>
          <div class="text-gray-500 mt-2">退货申请</div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="16">
        <el-card>
          <template #header>
            <div class="flex justify-between items-center">
              <span>销售趋势</span>
              <el-dropdown>
                <el-button type="primary" size="small">
                  近7天 <el-icon><ArrowDown /></el-icon>
                </el-button>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item>近7天</el-dropdown-item>
                    <el-dropdown-item>近30天</el-dropdown-item>
                    <el-dropdown-item>近90天</el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>
          </template>
          <div class="chart-placeholder h-80 flex items-center justify-center bg-gray-50 rounded">
            <div class="text-center text-gray-500">
              <el-icon :size="48"><TrendCharts /></el-icon>
              <p class="mt-2">销售趋势图表</p>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card>
          <template #header>
            <span>最新订单</span>
          </template>
          <el-table :data="recentOrders" style="width: 100%">
            <el-table-column prop="id" label="订单号" width="120" />
            <el-table-column prop="customer" label="客户" />
            <el-table-column prop="amount" label="金额" width="100" />
            <el-table-column prop="status" label="状态" width="100">
              <template #default="{ row }">
                <el-tag :type="getStatusType(row.status)">
                  {{ row.status }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ArrowDown, TrendCharts } from '@element-plus/icons-vue'

const recentOrders = ref([
  { id: '20230001', customer: '张三', amount: '¥298.00', status: '待发货' },
  { id: '20230002', customer: '李四', amount: '¥156.50', status: '已发货' },
  { id: '20230003', customer: '王五', amount: '¥872.00', status: '已完成' },
  { id: '20230004', customer: '赵六', amount: '¥423.80', status: '待付款' },
  { id: '20230005', customer: '钱七', amount: '¥645.20', status: '已取消' }
])

const getStatusType = (status) => {
  const statusMap = {
    '待付款': 'info',
    '待发货': 'warning',
    '已发货': 'primary',
    '已完成': 'success',
    '已取消': 'danger'
  }
  return statusMap[status] || 'info'
}
</script>

<style scoped>
.chart-placeholder {
  background: linear-gradient(45deg, #f8f9fa, #e9ecef);
}
</style>
