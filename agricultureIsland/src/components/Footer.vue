<template>
  <footer class="bg-white border-t border-surface py-12">
    <div class="container">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
        <div>
          <h3 class="text-lg font-bold mb-4">农品优选</h3>
          <p class="text-neutral-medium text-sm">
            专注优质农产品直供，连接田间与餐桌，为您提供新鲜、健康、可溯源的农产品。
          </p>
        </div>
        
        <div>
          <h4 class="font-semibold mb-4">快速链接</h4>
          <ul class="space-y-2">
            <li><router-link to="/" class="text-neutral-medium hover:text-primary-accent">首页</router-link></li>
            <li><router-link to="/products" class="text-neutral-medium hover:text-primary-accent">商品中心</router-link></li>
            <li><router-link to="/marketing" class="text-neutral-medium hover:text-primary-accent">优惠活动</router-link></li>
            <li><router-link to="/user" class="text-neutral-medium hover:text-primary-accent">用户中心</router-link></li>
          </ul>
        </div>
        
        <div>
          <h4 class="font-semibold mb-4">客户服务</h4>
          <ul class="space-y-2">
            <li><a href="#" class="text-neutral-medium hover:text-primary-accent">帮助中心</a></li>
            <li><a href="#" class="text-neutral-medium hover:text-primary-accent">售后服务</a></li>
            <li><a href="#" class="text-neutral-medium hover:text-primary-accent">物流查询</a></li>
            <li><a href="#" class="text-neutral-medium hover:text-primary-accent">联系我们</a></li>
          </ul>
        </div>
        
        <div>
          <h4 class="font-semibold mb-4">联系方式</h4>
          <ul class="space-y-2 text-neutral-medium">
            <li class="flex items-start">
              <el-icon class="mr-2 mt-1"><Location /></el-icon>
              <span>北京市朝阳区农业大厦123号</span>
            </li>
            <li class="flex items-center">
              <el-icon class="mr-2"><Phone /></el-icon>
              <span>400-123-4567</span>
            </li>
            <li class="flex items-center">
              <el-icon class="mr-2"><Message /></el-icon>
              <span>service@agripremium.com</span>
            </li>
          </ul>
        </div>
      </div>
      
      <div class="border-t border-surface mt-8 pt-8 text-center text-neutral-medium text-sm">
        <p>© 2025 农品优选 版权所有 | 京ICP备12345678号</p>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { Location, Phone, Message } from '@element-plus/icons-vue'
</script>
