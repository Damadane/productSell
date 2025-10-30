<template>
  <el-container>
    <el-header class="bg-blue-600 text-white p-4 flex items-center justify-between">
      <h1 class="text-xl font-bold">农产品销售管理系统</h1>
      <div class="flex items-center space-x-4">
        <el-dropdown>
          <el-avatar :size="32" src="https://www.weavefox.cn/api/bolt/unsplash_image?keyword=administrator&width=100&height=100&random=administrator_100_100" />
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item @click="logout">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </el-header>
    
    <el-container>
      <el-aside width="200px" class="bg-gray-100 min-h-screen">
        <el-menu
          :default-active="activeMenu"
          class="border-r-0"
          @select="handleMenuSelect"
        >
          <el-menu-item index="/dashboard">
            <el-icon><House /></el-icon>
            <span>仪表盘</span>
          </el-menu-item>
          
          <el-sub-menu index="products">
            <template #title>
              <el-icon><Box /></el-icon>
              <span>商品管理</span>
            </template>
            <el-menu-item index="/products/list">商品列表</el-menu-item>
            <el-menu-item index="/products/categories">分类管理</el-menu-item>
            <el-menu-item index="/products/inventory">库存管理</el-menu-item>
          </el-sub-menu>
          
          <el-sub-menu index="orders">
            <template #title>
              <el-icon><Document /></el-icon>
              <span>订单管理</span>
            </template>
            <el-menu-item index="/orders/list">订单列表</el-menu-item>
            <el-menu-item index="/orders/refund">退货管理</el-menu-item>
          </el-sub-menu>
          
          <el-sub-menu index="users">
            <template #title>
              <el-icon><User /></el-icon>
              <span>用户管理</span>
            </template>
            <el-menu-item index="/users/list">客户管理</el-menu-item>
            <el-menu-item index="/users/merchants">商家管理</el-menu-item>
            <el-menu-item index="/users/delivery">配送员管理</el-menu-item>
            <el-menu-item index="/users/members">会员管理</el-menu-item>
          </el-sub-menu>
          
          <el-sub-menu index="logistics">
            <template #title>
              <el-icon><Truck /></el-icon>
              <span>物流管理</span>
            </template>
            <el-menu-item index="/logistics/list">物流列表</el-menu-item>
            <el-menu-item index="/logistics/carriers">物流公司</el-menu-item>
          </el-sub-menu>
          
          <el-sub-menu index="marketing">
            <template #title>
              <el-icon><TrendCharts /></el-icon>
              <span>营销管理</span>
            </template>
            <el-menu-item index="/marketing/coupons">优惠券</el-menu-item>
            <el-menu-item index="/marketing/promotions">促销活动</el-menu-item>
            <el-menu-item index="/marketing/recommendations">商品推荐</el-menu-item>
          </el-sub-menu>
          
          <el-menu-item index="/system">
            <el-icon><Setting /></el-icon>
            <span>系统设置</span>
          </el-menu-item>
        </el-menu>
      </el-aside>
      
      <el-main class="p-6">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { 
  House, 
  Box, 
  Document, 
  User, 
  Truck, 
  TrendCharts, 
  Setting 
} from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const activeMenu = ref(route.path)

const handleMenuSelect = (index) => {
  router.push(index)
}

const logout = () => {
  // 模拟退出登录
  console.log('退出登录')
}

onMounted(() => {
  activeMenu.value = route.path
})
</script>

<style scoped>
.el-header {
  box-shadow: 0 2px 4px rgba(0,0,0,.05);
}
.el-aside {
  box-shadow: 2px 0 4px rgba(0,0,0,.05);
}
</style>
