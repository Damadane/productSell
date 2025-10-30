<template>
  <div class="card overflow-hidden transition-transform duration-300 hover:scale-105">
    <div class="relative">
      <img 
        :src="product.image" 
        :alt="product.name" 
        class="w-full h-48 object-cover"
        loading="lazy"
      >
      <div v-if="product.originalPrice && product.originalPrice > product.price" class="absolute top-2 right-2 bg-support-accent text-white text-xs font-bold px-2 py-1 rounded">
        热销
      </div>
    </div>
    <div class="p-4">
      <h3 class="font-semibold mb-1 truncate">{{ product.name }}</h3>
      <div class="flex items-center mb-2">
        <el-rate
          v-model="product.rating"
          disabled
          size="small"
          :max="5"
        />
        <span class="text-neutral-medium text-sm ml-2">{{ product.rating }}</span>
      </div>
      <div class="flex items-center justify-between">
        <div>
          <span class="text-primary-accent font-bold">¥{{ product.price }}</span>
          <span v-if="product.originalPrice && product.originalPrice > product.price" class="text-neutral-medium text-sm line-through ml-2">¥{{ product.originalPrice }}</span>
        </div>
        <button class="btn-primary text-sm py-1 px-3" @click="viewDetails">立即购买</button>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  product: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['view-details'])

const viewDetails = () => {
  emit('view-details', product.id)
}
</script>
