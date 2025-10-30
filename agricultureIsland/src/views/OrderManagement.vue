<template>
  <div class="container py-8">
    <el-breadcrumb separator="/" class="mb-6">
      <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item>订单管理</el-breadcrumb-item>
    </el-breadcrumb>
    
    <div class="card">
      <div class="border-b border-surface p-6">
        <h2 class="text-xl font-bold">订单管理</h2>
      </div>
      
      <div class="p-6">
        <div class="flex flex-wrap items-center justify-between mb-6 gap-4">
          <div class="flex flex-wrap gap-4">
            <el-select v-model="filterStatus" placeholder="订单状态" class="w-32">
              <el-option label="全部状态" value="" />
              <el-option label="待付款" value="pending" />
              <el-option label="待发货" value="paid" />
              <el-option label="待收货" value="shipping" />
              <el-option label="已完成" value="completed" />
              <el-option label="已取消" value="cancelled" />
            </el-select>
            
            <el-date-picker
              v-model="dateRange"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              format="YYYY-MM-DD"
              value-format="YYYY-MM-DD"
            />
          </div>
          
          <el-input
            v-model="searchKeyword"
            placeholder="搜索订单号或商品名称"
            class="w-64"
            clearable
          >
            <template #suffix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
        </div>
        
        <div v-if="loading" class="text-center py-12">
          <el-skeleton :rows="5" animated />
        </div>
        
        <el-table v-else :data="filteredOrders" style="width: 100%">
          <el-table-column prop="id" label="订单号" width="180" />
          <el-table-column prop="date" label="下单时间" width="120" />
          <el-table-column label="商品信息">
            <template #default="{ row }">
              <div class="flex items-center" v-for="item in row.items" :key="item.id">
                <img :src="item.image" :alt="item.name" class="w-12 h-12 object-cover rounded mr-3">
                <div>
                  <p class="font-medium">{{ item.name }}</p>
                  <p class="text-neutral-medium text-sm">数量: {{ item.quantity }}</p>
                </div>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="total" label="订单金额" width="100">
            <template #default="{ row }">
              <span class="font-bold text-primary-accent">¥{{ row.total }}</span>
            </template>
          </el-table-column>
          <el-table-column label="订单状态" width="100">
            <template #default="{ row }">
              <el-tag :type="getOrderStatusType(row.status)">
                {{ row.statusText }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="150">
            <template #default="{ row }">
              <el-button 
                v-if="row.status === 'pending'" 
                type="primary" 
                size="small" 
                @click="payOrder(row)"
              >
                立即付款
              </el-button>
              <el-button 
                v-else-if="row.status === 'shipping'" 
                size="small" 
                @click="confirmReceipt(row)"
              >
                确认收货
              </el-button>
              <el-button 
                v-else 
                size="small" 
                @click="viewOrder(row)"
              >
                查看详情
              </el-button>
            </template>
          </el-table-column>
        </el-table>
        
        <div class="flex justify-center mt-8">
          <el-pagination
            v-model:current-page="currentPage"
            :page-size="pageSize"
            :total="totalOrders"
            layout="prev, pager, next"
            background
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { Search } from '@element-plus/icons-vue'
import { supabase } from '../supabaseClient'

// 状态
const loading = ref(false)

// 筛选条件
const filterStatus = ref('')
const dateRange = ref('')
const searchKeyword = ref('')
const currentPage = ref(1)
const pageSize = ref(5)

// 订单数据（模拟）
const orders = ref([])

// 从数据库获取订单数据
const fetchOrders = async () => {
  loading.value = true
  try {
    // 获取当前用户ID（模拟）
    const userId = 'user123'
    
    const { data, error } = await supabase
      .from('orders_46935')
      .select('*')
      .eq('user_id', userId)
      
    if (error) throw error
    
    // 转换数据格式
    orders.value = data.map(order => ({
      id: order.id,
      date: new Date(order.created_at).toLocaleDateString(),
      items: order.items.map(item => ({
        id: item.id,
        name: item.name,
        image: item.image || 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=product&width=50&height=50&random=product_order_manage_50_50',
        price: parseFloat(item.price),
        quantity: item.quantity
      })),
      total: parseFloat(order.total),
      status: order.status,
      statusText: getStatusText(order.status)
    }))
  } catch (error) {
    console.error('获取订单数据失败:', error)
    // 出错时使用模拟数据
    orders.value = [
      {
        id: '20251025001',
        date: '2025-10-25',
        items: [
          { id: 1, name: '有机苹果', image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=apple&width=50&height=50&random=apple_order_manage_50_50', price: 29.9, quantity: 2 },
          { id: 2, name: '新鲜菠菜', image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=spinach&width=50&height=50&random=spinach_order_manage_50_50', price: 12.8, quantity: 1 }
        ],
        total: 72.6,
        status: 'completed',
        statusText: '已完成'
      },
      {
        id: '20251020002',
        date: '2025-10-20',
        items: [
          { id: 3, name: '农家土鸡蛋', image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=eggs&width=50&height=50&random=eggs_order_manage_50_50', price: 32.5, quantity: 1 }
        ],
        total: 32.5,
        status: 'shipping',
        statusText: '待收货'
      },
      {
        id: '20251015003',
        date: '2025-10-15',
        items: [
          { id: 4, name: '东北大米', image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=rice&width=50&height=50&random=rice_order_manage_50_50', price: 45.0, quantity: 1 }
        ],
        total: 45.0,
        status: 'pending',
        statusText: '待付款'
      },
      {
        id: '20251010004',
        date: '2025-10-10',
        items: [
          { id: 5, name: '新疆葡萄干', image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=raisins&width=50&height=50&random=raisins_order_manage_50_50', price: 28.0, quantity: 2 }
        ],
        total: 56.0,
        status: 'paid',
        statusText: '待发货'
      },
      {
        id: '20251005005',
        date: '2025-10-05',
        items: [
          { id: 6, name: '海南芒果', image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=mango&width=50&height=50&random=mango_order_manage_50_50', price: 36.8, quantity: 1 }
        ],
        total: 36.8,
        status: 'cancelled',
        statusText: '已取消'
      }
    ]
  } finally {
    loading.value = false
  }
}

// 获取订单状态文本
const getStatusText = (status) => {
  switch (status) {
    case 'pending': return '待付款'
    case 'paid': return '待发货'
    case 'shipping': return '待收货'
    case 'completed': return '已完成'
    case 'cancelled': return '已取消'
    default: return '未知状态'
  }
}

// 筛选后的订单
const filteredOrders = computed(() => {
  let result = [...orders.value]
  
  // 状态筛选
  if (filterStatus.value) {
    result = result.filter(order => order.status === filterStatus.value)
  }
  
  // 日期筛选
  if (dateRange.value && dateRange.value.length === 2) {
    const [startDate, endDate] = dateRange.value
    result = result.filter(order => {
      const orderDate = new Date(order.date)
      return orderDate >= new Date(startDate) && orderDate <= new Date(endDate)
    })
  }
  
  // 关键词搜索
  if (searchKeyword.value) {
    const keyword = searchKeyword.value.toLowerCase()
    result = result.filter(order => 
      order.id.includes(keyword) || 
      order.items.some(item => item.name.toLowerCase().includes(keyword))
    )
  }
  
  return result
})

// 总订单数
const totalOrders = computed(() => filteredOrders.value.length)

// 获取订单状态类型
const getOrderStatusType = (status) => {
  switch (status) {
    case 'pending': return 'warning'
    case 'paid': return ''
    case 'shipping': return ''
    case 'completed': return 'success'
    case 'cancelled': return 'danger'
    default: return ''
  }
}

// 支付订单
const payOrder = (order) => {
  console.log('支付订单:', order.id)
  alert(`正在支付订单 ${order.id}`)
  // 实际项目中这里会跳转到支付页面
}

// 确认收货
const confirmReceipt = (order) => {
  console.log('确认收货:', order.id)
  alert(`确认收货订单 ${order.id}`)
  // 实际项目中这里会更新订单状态
}

// 查看订单详情
const viewOrder = (order) => {
  console.log('查看订单详情:', order.id)
  alert(`查看订单详情 ${order.id}`)
  // 实际项目中这里会跳转到订单详情页面
}

onMounted(() => {
  fetchOrders()
})
</script>
