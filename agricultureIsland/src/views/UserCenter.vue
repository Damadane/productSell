<template>
  <div class="container py-8">
    <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
      <!-- 侧边栏 -->
      <div class="lg:col-span-1">
        <div class="card">
          <div class="p-6 text-center">
            <div class="relative mx-auto mb-4">
              <img 
                src="https://www.weavefox.cn/api/bolt/unsplash_image?keyword=user,avatar&width=100&height=100&random=user_avatar_100_100" 
                alt="用户头像" 
                class="w-20 h-20 rounded-full mx-auto"
              >
              <button class="absolute bottom-0 right-1/4 bg-white rounded-full p-1 shadow-md">
                <el-icon><Camera /></el-icon>
              </button>
            </div>
            <h2 class="text-xl font-bold">{{ user.name }}</h2>
            <p class="text-neutral-medium mb-4">{{ user.email }}</p>
            
            <div class="bg-surface rounded-lg p-4 mb-4">
              <p class="text-sm text-neutral-medium mb-1">会员等级</p>
              <div class="flex items-center">
                <el-tag type="success">{{ user.membershipLevel }}</el-tag>
                <span class="ml-2 text-sm">经验值: {{ user.experience }}</span>
              </div>
            </div>
            
            <div class="bg-surface rounded-lg p-4">
              <p class="text-sm text-neutral-medium mb-1">我的积分</p>
              <p class="text-2xl font-bold text-primary-accent">{{ user.points }}</p>
            </div>
          </div>
          
          <div class="border-t border-surface">
            <el-menu
              :default-active="activeMenu"
              class="border-0"
              @select="handleMenuSelect"
            >
              <el-menu-item index="profile">
                <el-icon><User /></el-icon>
                <span>个人信息</span>
              </el-menu-item>
              <el-menu-item index="orders">
                <el-icon><Tickets /></el-icon>
                <span>我的订单</span>
              </el-menu-item>
              <el-menu-item index="coupons">
                <el-icon><Ticket /></el-icon>
                <span>优惠券</span>
              </el-menu-item>
              <el-menu-item index="address">
                <el-icon><Location /></el-icon>
                <span>收货地址</span>
              </el-menu-item>
              <el-menu-item index="security">
                <el-icon><Lock /></el-icon>
                <span>安全设置</span>
              </el-menu-item>
            </el-menu>
          </div>
        </div>
      </div>
      
      <!-- 主内容区 -->
      <div class="lg:col-span-3">
        <div class="card">
          <div class="border-b border-surface p-6">
            <h2 class="text-xl font-bold">
              <span v-if="activeMenu === 'profile'">个人信息</span>
              <span v-else-if="activeMenu === 'orders'">我的订单</span>
              <span v-else-if="activeMenu === 'coupons'">我的优惠券</span>
              <span v-else-if="activeMenu === 'address'">收货地址</span>
              <span v-else-if="activeMenu === 'security'">安全设置</span>
            </h2>
          </div>
          
          <div class="p-6">
            <!-- 个人信息 -->
            <div v-if="activeMenu === 'profile'">
              <el-form :model="user" label-width="100px">
                <el-form-item label="用户名">
                  <el-input v-model="user.name" />
                </el-form-item>
                <el-form-item label="手机号">
                  <el-input v-model="user.phone" />
                </el-form-item>
                <el-form-item label="邮箱">
                  <el-input v-model="user.email" />
                </el-form-item>
                <el-form-item label="性别">
                  <el-radio-group v-model="user.gender">
                    <el-radio label="男" />
                    <el-radio label="女" />
                  </el-radio-group>
                </el-form-item>
                <el-form-item label="生日">
                  <el-date-picker
                    v-model="user.birthday"
                    type="date"
                    placeholder="选择日期"
                    format="YYYY-MM-DD"
                    value-format="YYYY-MM-DD"
                  />
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="updateProfile">保存信息</el-button>
                </el-form-item>
              </el-form>
            </div>
            
            <!-- 我的订单 -->
            <div v-else-if="activeMenu === 'orders'">
              <el-tabs v-model="orderTab">
                <el-tab-pane label="全部订单" name="all">
                  <OrderList :orders="orders" />
                </el-tab-pane>
                <el-tab-pane label="待付款" name="pending">
                  <OrderList :orders="orders.filter(o => o.status === 'pending')" />
                </el-tab-pane>
                <el-tab-pane label="待收货" name="shipping">
                  <OrderList :orders="orders.filter(o => o.status === 'shipping')" />
                </el-tab-pane>
                <el-tab-pane label="已完成" name="completed">
                  <OrderList :orders="orders.filter(o => o.status === 'completed')" />
                </el-tab-pane>
              </el-tabs>
            </div>
            
            <!-- 我的优惠券 -->
            <div v-else-if="activeMenu === 'coupons'">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div 
                  v-for="coupon in coupons" 
                  :key="coupon.id"
                  class="border rounded-lg p-4 flex justify-between items-center"
                  :class="{
                    'border-primary-accent bg-surface': coupon.status === 'available',
                    'border-neutral-medium bg-surface': coupon.status === 'used' || coupon.status === 'expired'
                  }"
                >
                  <div>
                    <div class="flex items-center">
                      <span class="text-2xl font-bold text-primary-accent mr-2">¥{{ coupon.amount }}</span>
                      <span class="text-neutral-medium">满{{ coupon.minAmount }}可用</span>
                    </div>
                    <p class="font-medium my-1">{{ coupon.name }}</p>
                    <p class="text-sm text-neutral-medium">有效期至 {{ coupon.expiryDate }}</p>
                  </div>
                  <el-tag :type="coupon.status === 'available' ? 'success' : coupon.status === 'used' ? 'info' : 'danger'">
                    {{ coupon.statusText }}
                  </el-tag>
                </div>
              </div>
            </div>
            
            <!-- 收货地址 -->
            <div v-else-if="activeMenu === 'address'">
              <div class="mb-4">
                <el-button type="primary" @click="showAddressDialog = true">
                  <el-icon class="mr-1"><Plus /></el-icon>添加新地址
                </el-button>
              </div>
              
              <div class="space-y-4">
                <div 
                  v-for="address in addresses" 
                  :key="address.id"
                  class="border border-surface rounded-lg p-4 flex justify-between items-start"
                >
                  <div>
                    <p class="font-medium">{{ address.name }}</p>
                    <p class="text-neutral-medium my-1">{{ address.phone }}</p>
                    <p>{{ address.province }}{{ address.city }}{{ address.district }}{{ address.detail }}</p>
                    <p class="text-sm text-neutral-medium mt-2">{{ address.postalCode }}</p>
                  </div>
                  <div>
                    <el-button 
                      v-if="address.isDefault" 
                      size="small" 
                      type="success" 
                      plain 
                      disabled
                    >
                      默认地址
                    </el-button>
                    <div class="flex space-x-2 mt-2">
                      <el-button size="small" @click="editAddress(address)">编辑</el-button>
                      <el-button size="small" @click="deleteAddress(address.id)">删除</el-button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- 安全设置 -->
            <div v-else-if="activeMenu === 'security'">
              <el-form :model="securityForm" label-width="120px">
                <el-form-item label="原密码">
                  <el-input v-model="securityForm.oldPassword" type="password" show-password />
                </el-form-item>
                <el-form-item label="新密码">
                  <el-input v-model="securityForm.newPassword" type="password" show-password />
                </el-form-item>
                <el-form-item label="确认新密码">
                  <el-input v-model="securityForm.confirmPassword" type="password" show-password />
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="changePassword">修改密码</el-button>
                </el-form-item>
              </el-form>
              
              <div class="border-t border-surface pt-6 mt-6">
                <h3 class="font-bold mb-4">账号绑定</h3>
                <div class="flex items-center justify-between p-4 bg-surface rounded-lg mb-4">
                  <div class="flex items-center">
                    <div class="bg-white w-10 h-10 rounded-full flex items-center justify-center mr-3">
                      <el-icon :size="20" color="#1DA1F2"><Message /></el-icon>
                    </div>
                    <div>
                      <p class="font-medium">手机号</p>
                      <p class="text-sm text-neutral-medium">{{ user.phone }}</p>
                    </div>
                  </div>
                  <el-button size="small">更换</el-button>
                </div>
                
                <div class="flex items-center justify-between p-4 bg-surface rounded-lg">
                  <div class="flex items-center">
                    <div class="bg-white w-10 h-10 rounded-full flex items-center justify-center mr-3">
                      <el-icon :size="20" color="#34C759"><Message /></el-icon>
                    </div>
                    <div>
                      <p class="font-medium">邮箱</p>
                      <p class="text-sm text-neutral-medium">{{ user.email }}</p>
                    </div>
                  </div>
                  <el-button size="small">更换</el-button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 地址编辑对话框 -->
    <el-dialog v-model="showAddressDialog" title="收货地址" width="500px">
      <el-form :model="addressForm" label-width="80px">
        <el-form-item label="姓名">
          <el-input v-model="addressForm.name" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="addressForm.phone" />
        </el-form-item>
        <el-form-item label="地区">
          <el-cascader
            v-model="addressForm.region"
            :options="regionOptions"
            :props="{ expandTrigger: 'hover' }"
          />
        </el-form-item>
        <el-form-item label="详细地址">
          <el-input v-model="addressForm.detail" type="textarea" />
        </el-form-item>
        <el-form-item label="邮政编码">
          <el-input v-model="addressForm.postalCode" />
        </el-form-item>
        <el-form-item label="设为默认">
          <el-switch v-model="addressForm.isDefault" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="showAddressDialog = false">取消</el-button>
          <el-button type="primary" @click="saveAddress">保存</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import OrderList from '../components/OrderList.vue'
import { supabase } from '../supabaseClient'
import {
  User,
  Tickets,
  Ticket,
  Location,
  Lock,
  Camera,
  Plus,
  Message
} from '@element-plus/icons-vue'

const router = useRouter()

// 当前激活的菜单
const activeMenu = ref('profile')

// 订单标签页
const orderTab = ref('all')

// 地址对话框显示状态
const showAddressDialog = ref(false)

// 用户信息
const user = ref({
  name: '张三',
  email: 'zhangsan@example.com',
  phone: '13800138000',
  gender: '男',
  birthday: '1990-01-01',
  membershipLevel: '黄金会员',
  experience: 2800,
  points: 1250
})

// 订单数据
const orders = ref([])

// 优惠券数据
const coupons = ref([
  {
    id: 1,
    name: '新人专享券',
    amount: 10,
    minAmount: 29,
    expiryDate: '2025-12-31',
    status: 'available',
    statusText: '未使用'
  },
  {
    id: 2,
    name: '满减优惠券',
    amount: 30,
    minAmount: 99,
    expiryDate: '2025-11-30',
    status: 'used',
    statusText: '已使用'
  },
  {
    id: 3,
    name: '节日大促券',
    amount: 50,
    minAmount: 199,
    expiryDate: '2025-10-20',
    status: 'expired',
    statusText: '已过期'
  }
])

// 地址数据
const addresses = ref([
  {
    id: 1,
    name: '张三',
    phone: '13800138000',
    province: '北京市',
    city: '北京市',
    district: '朝阳区',
    detail: '建国路88号现代城A座1201室',
    postalCode: '100020',
    isDefault: true
  },
  {
    id: 2,
    name: '张三',
    phone: '13800138000',
    province: '山东省',
    city: '烟台市',
    district: '芝罘区',
    detail: '胜利路123号',
    postalCode: '264000',
    isDefault: false
  }
])

// 安全设置表单
const securityForm = ref({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

// 地址表单
const addressForm = ref({
  id: null,
  name: '',
  phone: '',
  region: [],
  detail: '',
  postalCode: '',
  isDefault: false
})

// 地区选项（简化）
const regionOptions = ref([
  {
    value: '北京市',
    label: '北京市',
    children: [
      {
        value: '北京市',
        label: '北京市',
        children: [
          { value: '东城区', label: '东城区' },
          { value: '西城区', label: '西城区' },
          { value: '朝阳区', label: '朝阳区' },
          { value: '海淀区', label: '海淀区' }
        ]
      }
    ]
  },
  {
    value: '山东省',
    label: '山东省',
    children: [
      {
        value: '烟台市',
        label: '烟台市',
        children: [
          { value: '芝罘区', label: '芝罘区' },
          { value: '莱山区', label: '莱山区' },
          { value: '福山区', label: '福山区' }
        ]
      }
    ]
  }
])

// 菜单选择处理
const handleMenuSelect = (index) => {
  activeMenu.value = index
}

// 从数据库获取用户订单
const fetchUserOrders = async () => {
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
        image: item.image || 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=product&width=60&height=60&random=product_order_60_60',
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
          { id: 1, name: '有机苹果', image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=apple&width=60&height=60&random=apple_order_60_60', price: 29.9, quantity: 2 },
          { id: 2, name: '新鲜菠菜', image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=spinach&width=60&height=60&random=spinach_order_60_60', price: 12.8, quantity: 1 }
        ],
        total: 72.6,
        status: 'completed',
        statusText: '已完成'
      },
      {
        id: '20251020002',
        date: '2025-10-20',
        items: [
          { id: 3, name: '农家土鸡蛋', image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=eggs&width=60&height=60&random=eggs_order_60_60', price: 32.5, quantity: 1 }
        ],
        total: 32.5,
        status: 'shipping',
        statusText: '待收货'
      },
      {
        id: '20251015003',
        date: '2025-10-15',
        items: [
          { id: 4, name: '东北大米', image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=rice&width=60&height=60&random=rice_order_60_60', price: 45.0, quantity: 1 }
        ],
        total: 45.0,
        status: 'pending',
        statusText: '待付款'
      }
    ]
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

// 更新个人信息
const updateProfile = () => {
  console.log('更新个人信息:', user.value)
  alert('个人信息更新成功')
}

// 修改密码
const changePassword = () => {
  if (securityForm.value.newPassword !== securityForm.value.confirmPassword) {
    alert('新密码与确认密码不一致')
    return
  }
  console.log('修改密码:', securityForm.value)
  alert('密码修改成功')
}

// 编辑地址
const editAddress = (address) => {
  addressForm.value = {
    ...address,
    region: [address.province, address.city, address.district]
  }
  showAddressDialog.value = true
}

// 删除地址
const deleteAddress = (id) => {
  addresses.value = addresses.value.filter(addr => addr.id !== id)
  alert('地址删除成功')
}

// 保存地址
const saveAddress = () => {
  if (addressForm.value.region.length < 3) {
    alert('请选择完整的地区')
    return
  }
  
  const [province, city, district] = addressForm.value.region
  const addressData = {
    ...addressForm.value,
    province,
    city,
    district
  }
  
  if (addressData.id) {
    // 更新地址
    const index = addresses.value.findIndex(addr => addr.id === addressData.id)
    if (index !== -1) {
      addresses.value[index] = addressData
    }
  } else {
    // 新增地址
    addressData.id = Date.now()
    addresses.value.push(addressData)
  }
  
  showAddressDialog.value = false
  addressForm.value = {
    id: null,
    name: '',
    phone: '',
    region: [],
    detail: '',
    postalCode: '',
    isDefault: false
  }
  alert('地址保存成功')
}

onMounted(() => {
  fetchUserOrders()
})
</script>
