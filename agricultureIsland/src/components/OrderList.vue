<template>
  <div v-if="orders.length === 0" class="text-center py-12">
    <el-empty description="暂无订单记录" />
  </div>
  
  <div v-else class="space-y-6">
    <div 
      v-for="order in orders" 
      :key="order.id"
      class="border border-surface rounded-lg overflow-hidden"
    >
      <div class="bg-surface p-4 flex justify-between items-center">
        <div>
          <span class="font-medium">订单号: {{ order.id }}</span>
          <span class="mx-2">|</span>
          <span class="text-neutral-medium">{{ order.date }}</span>
        </div>
        <el-tag :type="getOrderStatusType(order.status)">
          {{ order.statusText }}
        </el-tag>
      </div>
      
      <div class="p-4">
        <div class="flex items-center mb-4" v-for="item in order.items" :key="item.id">
          <img :src="item.image" :alt="item.name" class="w-16 h-16 object-cover rounded mr-4">
          <div class="flex-1">
            <h4 class="font-medium">{{ item.name }}</h4>
            <p class="text-neutral-medium">数量: {{ item.quantity }}</p>
          </div>
          <div class="text-right">
            <p class="font-medium">¥{{ item.price }}</p>
          </div>
        </div>
        
        <div class="border-t border-surface pt-4 flex justify-between items-center">
          <p>共 {{ order.items.length }} 件商品</p>
          <div class="text-right">
            <p class="text-lg font-bold">合计: <span class="text-primary-accent">¥{{ order.total }}</span></p>
            <div class="flex justify-end space-x-2 mt-2">
              <el-button v-if="order.status === 'pending'" type="primary" size="small">立即付款</el-button>
              <el-button v-if="order.status === 'shipping'" size="small">确认收货</el-button>
              <el-button size="small" @click="viewOrder(order.id)">查看详情</el-button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  orders: {
    type: Array,
    required: true
  }
})

const getOrderStatusType = (status) => {
  switch (status) {
    case 'pending': return 'warning'
    case 'shipping': return ''
    case 'completed': return 'success'
    case 'cancelled': return 'danger'
    default: return ''
  }
}

const viewOrder = (orderId) => {
  console.log('查看订单详情:', orderId)
  // 这里可以跳转到订单详情页面
}
</script>
