<template>
  <div class="system-settings">
    <el-tabs v-model="activeTab">
      <el-tab-pane label="基本设置" name="basic">
        <el-card>
          <template #header>
            <span>平台基本信息</span>
          </template>
          
          <el-form :model="basicSettings" label-width="120px">
            <el-form-item label="平台名称">
              <el-input v-model="basicSettings.platformName" />
            </el-form-item>
            <el-form-item label="平台Logo">
              <el-upload
                class="avatar-uploader"
                action="#"
                :show-file-list="false"
              >
                <img v-if="basicSettings.logo" :src="basicSettings.logo" class="avatar" />
                <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
              </el-upload>
            </el-form-item>
            <el-form-item label="平台描述">
              <el-input
                v-model="basicSettings.description"
                type="textarea"
                :rows="4"
                placeholder="请输入平台描述"
              />
            </el-form-item>
            <el-form-item label="客服电话">
              <el-input v-model="basicSettings.servicePhone" />
            </el-form-item>
            <el-form-item label="客服邮箱">
              <el-input v-model="basicSettings.serviceEmail" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="saveBasicSettings">保存设置</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="权限管理" name="permissions">
        <el-card>
          <template #header>
            <div class="flex justify-between items-center">
              <span>角色权限管理</span>
              <el-button type="primary" @click="addRole">添加角色</el-button>
            </div>
          </template>
          
          <el-table :data="roles" border style="width: 100%">
            <el-table-column prop="id" label="角色ID" width="100" />
            <el-table-column prop="name" label="角色名称" width="150" />
            <el-table-column prop="description" label="描述" />
            <el-table-column prop="userCount" label="用户数量" width="120" />
            <el-table-column label="操作" width="200">
              <template #default="{ row }">
                <el-button size="small" type="primary" @click="editRole(row)">编辑权限</el-button>
                <el-button size="small" type="danger" @click="deleteRole(row)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="系统日志" name="logs">
        <el-card>
          <template #header>
            <div class="flex justify-between items-center">
              <span>操作日志</span>
              <div class="flex space-x-2">
                <el-date-picker
                  v-model="logDateRange"
                  type="daterange"
                  range-separator="至"
                  start-placeholder="开始日期"
                  end-placeholder="结束日期"
                  style="width: 250px"
                />
                <el-button type="primary">搜索</el-button>
              </div>
            </div>
          </template>
          
          <el-table :data="logs" border style="width: 100%">
            <el-table-column prop="id" label="日志ID" width="100" />
            <el-table-column prop="operator" label="操作人" width="120" />
            <el-table-column prop="action" label="操作内容" />
            <el-table-column prop="ip" label="操作IP" width="150" />
            <el-table-column prop="time" label="操作时间" width="180" />
          </el-table>
          
          <div class="mt-4 flex justify-end">
            <el-pagination
              :current-page="logCurrentPage"
              :page-size="logPageSize"
              :total="logTotal"
              layout="prev, pager, next"
              @current-change="handleLogPageChange"
            />
          </div>
        </el-card>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'

const activeTab = ref('basic')

// 基本设置
const basicSettings = ref({
  platformName: '农产品销售平台',
  logo: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=agricultural&width=100&height=100&random=agricultural_100_100',
  description: '专注于为消费者提供优质农产品，连接农户与消费者，打造绿色健康的生活方式',
  servicePhone: '400-123-4567',
  serviceEmail: 'service@agriplatform.com'
})

// 权限管理
const roles = ref([
  {
    id: 1,
    name: '管理员',
    description: '系统超级管理员',
    userCount: 5
  },
  {
    id: 2,
    name: '商家',
    description: '农产品供应商',
    userCount: 42
  },
  {
    id: 3,
    name: '配送员',
    description: '物流配送人员',
    userCount: 18
  }
])

// 系统日志
const logDateRange = ref('')
const logCurrentPage = ref(1)
const logPageSize = ref(10)
const logTotal = ref(200)

const logs = ref([
  {
    id: 'L10001',
    operator: 'admin',
    action: '修改商品信息',
    ip: '192.168.1.100',
    time: '2023-05-15 14:30:22'
  },
  {
    id: 'L10002',
    operator: 'merchant1',
    action: '添加新商品',
    ip: '192.168.1.105',
    time: '2023-05-15 12:15:45'
  }
])

const saveBasicSettings = () => {
  ElMessage.success('保存设置成功')
}

const addRole = () => {
  ElMessage.info('添加角色功能')
}

const editRole = (role) => {
  ElMessage.info(`编辑角色权限: ${role.name}`)
}

const deleteRole = (role) => {
  ElMessageBox.confirm(
    `确定要删除角色 "${role.name}" 吗?`,
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

const handleLogPageChange = (page) => {
  logCurrentPage.value = page
  ElMessage.info(`跳转到第 ${page} 页`)
}
</script>

<style scoped>
.avatar-uploader .avatar {
  width: 100px;
  height: 100px;
  display: block;
}
.avatar-uploader :deep(.el-upload) {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
}
.avatar-uploader :deep(.el-upload:hover) {
  border-color: var(--el-color-primary);
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 100px;
  height: 100px;
  text-align: center;
}
</style>
