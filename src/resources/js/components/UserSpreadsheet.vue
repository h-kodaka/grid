<template>
    <h1 class="text-2xl font-bold">ユーザー一覧</h1>
    <Spreadsheet v-if="!isLoading" :key="spreadsheetKey" :tabs="false" :toolbar="false">
        <Worksheet :columns="columns" :data="data" />
    </Spreadsheet>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import axios from 'axios'
// @see https://bossanova.uk/jspreadsheet/docs
import { Spreadsheet, Worksheet } from "@jspreadsheet-ce/vue";
import "jsuites/dist/jsuites.css";
import "jspreadsheet-ce/dist/jspreadsheet.css";


const isLoading = ref(true)
const spreadsheetKey = ref(0)
const columns = [
    { title: 'ID', type: 'text', width: 100, align: 'left' },
    { title: '名前', type: 'text', width: 200, align: 'left' },
    { title: 'メールアドレス', type: 'text', width: 300, align: 'left' },
    { title: '作成日', type: 'text', width: 300, align: 'left' },
    { title: '更新日', type: 'text', width: 300, align: 'left' }
]
const data = ref([])

onMounted(async () => {
    try {
        const response = await axios.get('/api/users')
        
        // データを配列形式に変換
        const users = response.data.map(user => {
            return [
                user.id || '',
                user.name || '',
                user.email || '',
                user.created_at || '',
                user.updated_at || ''
            ]
        })
        data.value = users
        spreadsheetKey.value++ // 再描画
    } catch (error) {
        console.error('Error:', error)
    } finally {
        isLoading.value = false
    }
})
</script>
