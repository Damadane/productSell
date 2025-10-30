<template>
  <div class="container py-8">
    <el-breadcrumb separator="/" class="mb-6">
      <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item>物流跟踪</el-breadcrumb-item>
    </el-breadcrumb>
    
    <div class="card">
      <div class="border-b border-surface p-6">
        <h2 class="text-xl font-bold">物流跟踪</h2>
      </div>
      
      <div class="p-6">
        <div class="mb-8">
          <el-input
            v-model="trackingNumber"
            placeholder="请输入运单号"
            class="max-w-md"
            size="large"
            @keyup.enter="trackOrder"
          >
            <template #append>
              <el-button type="primary" @click="trackOrder">查询</el-button>
            </template>
          </el-input>
        </div>
        
        <div v-if="currentTracking">
          <div class="flex flex-col md:flex-row gap-8">
            <div class="md:w-1/3">
              <div class="card p-6 mb-6">
                <h3 class="font-bold text-lg mb-4">订单信息</h3>
                <div class="space-y-3">
                  <div>
                    <p class="text-neutral-medium text-sm">运单号</p>
                    <p class="font-medium">{{ currentTracking.trackingNumber }}</p>
                  </div>
                  <div>
                    <p class="text-neutral-medium text-sm">物流公司</p>
                    <p class="font-medium">{{ currentTracking.company }}</p>
                  </div>
                  <div>
                    <p class="text-neutral-medium text-sm">发货时间</p>
                    <p class="font-medium">{{ currentTracking.shipDate }}</p>
                  </div>
                  <div>
                    <p class="text-neutral-medium text-sm">预计到达</p>
                    <p class="font-medium">{{ currentTracking.estimatedDelivery }}</p>
                  </div>
                  <div>
                    <p class="text-neutral-medium text-sm">收货信息</p>
                    <p class="font-medium">{{ currentTracking.recipient }}</p>
                    <p class="text-neutral-medium text-sm">{{ currentTracking.address }}</p>
                  </div>
                </div>
              </div>
              
              <div class="card p-6">
                <h3 class="font-bold text-lg mb-4">商品信息</h3>
                <div class="space-y-4">
                  <div 
                    v-for="item in currentTracking.items" 
                    :key="item.id"
                    class="flex items-center"
                  >
                    <img :src="item.image" :alt="item.name" class="w-16 h-16 object-cover rounded mr-4">
                    <div>
                      <h4 class="font-medium">{{ item.name }}</h4>
                      <p class="text-neutral-medium">数量: {{ item.quantity }}</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="md:w-2/3">
              <div class="card p-6">
                <h3 class="font-bold text-lg mb-6">物流进度</h3>
                <el-steps direction="vertical" :active="currentTracking.activeStep" finish-status="success">
                  <el-step 
                    v-for="(step, index) in currentTracking.steps" 
                    :key="index"
                    :title="step.title"
                    :description="step.description"
                    :status="step.status"
                  />
                </el-steps>
              </div>
              
              <div class="card p-6 mt-6">
                <h3 class="font-bold text-lg mb-4">物流详情</h3>
                <el-table :data="currentTracking.details" style="width: 100%">
                  <el-table-column prop="time" label="时间" width="180" />
                  <el-table-column prop="location" label="地点" />
                  <el-table-column prop="status" label="状态" width="150" />
                </el-table>
              </div>
            </div>
          </div>
        </div>
        
        <div v-else class="text-center py-12">
          <el-empty description="请输入运单号查询物流信息">
            <el-button type="primary" @click="fillExample">查看示例</el-button>
          </el-empty>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

// 运单号输入
const trackingNumber = ref('')

// 当前物流信息
const currentTracking = ref(null)

// 示例物流数据
const trackingData = {
  'SF123456789CN': {
    trackingNumber: 'SF123456789CN',
    company: '顺丰速运',
    shipDate: '2025-10-25 14:30',
    estimatedDelivery: '2025-10-27 18:00',
    recipient: '张三',
    address: '北京市朝阳区建国路88号现代城A座1201室',
    items: [
      { id: 1, name: '有机苹果', image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=apple&width=60&height=60&random=apple_logistics_60_60', quantity: 2 },
      { id: 2, name: '新鲜菠菜', image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=spinach&width=60&height=60&random=spinach_logistics_60_60', quantity: 1 }
    ],
    activeStep: 2,
    steps: [
      { title: '已下单', description: '2025-10-25 14:30', status: 'success' },
      { title: '已发货', description: '2025-10-25 16:45', status: 'success' },
      { title: '运输中', description: '当前位于北京转运中心', status: 'process' },
      { title: '派送中', description: '预计明天送达', status: 'wait' },
      { title: '已签收', description: '', status: 'wait' }
    ],
    details: [
      { time: '2025-10-25 16:45', location: '山东烟台仓库', status: '已发货' },
      { time: '2025-10-25 19:20', location: '烟台转运中心', status: '已揽收' },
      { time: '2025-10-26 05:30', location: '北京转运中心', status: '运输中' },
      { time: '2025-10-26 10:15', location: '北京朝阳区网点', status: '派送中' }
    ]
  }
}

// 查询物流
const trackOrder = () => {
  if (!trackingNumber.value) {
    alert('请输入运单号')
    return
  }
  
  // 模拟查询
  if (trackingData[trackingNumber.value]) {
    currentTracking.value = trackingData[trackingNumber.value]
  } else {
    alert('未找到该运单号的物流信息')
  }
}

// 填充示例运单号
const fillExample = () => {
  trackingNumber.value = 'SF123456789CN'
  trackOrder()
}
</script>
