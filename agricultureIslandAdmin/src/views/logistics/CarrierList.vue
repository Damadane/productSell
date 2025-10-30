<template>
  <div class="carrier-list">
    <el-card>
      <template #header>
        <div class="flex justify-between items-center">
          <span>物流公司管理</span>
          <el-button type="primary" @click="addCarrier">添加物流公司</el-button>
        </div>
      </template>
      
      <el-table :data="carriers" border style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="公司名称" width="150" />
        <el-table-column prop="contact" label="联系人" width="120" />
        <el-table-column prop="phone" label="联系电话" width="120" />
        <el-table-column prop="address" label="地址" />
        <el-table-column prop="enabled" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.enabled ? 'success' : 'info'">
              {{ row.enabled ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="editCarrier(row)">编辑</el-button>
            <el-button size="small" :type="row.enabled ? 'info' : 'success'" @click="toggleCarrier(row)">
              {{ row.enabled ? '禁用' : '启用' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const carriers = ref([
  {
    id: 1,
    name: '顺丰速运',
    contact: '王经理',
    phone: '400-111-1111',
    address: '深圳市南山区',
    enabled: true
  },
  {
    id: 2,
    name: '圆通快递',
    contact: '李主管',
    phone: '400-222-2222',
    address: '上海市青浦区',
    enabled: true
  }
])

const addCarrier = () => {
  ElMessage.info('添加物流公司功能')
}

const editCarrier = (carrier) => {
  ElMessage.info(`编辑物流公司: ${carrier.name}`)
}

const toggleCarrier = (carrier) => {
  const actionText = carrier.enabled ? '禁用' : '启用'
  ElMessage.success(`已${actionText}物流公司: ${carrier.name}`)
}
</script>
