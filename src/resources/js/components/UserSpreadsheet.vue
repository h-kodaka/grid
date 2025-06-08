<template>
    <h1 class="text-2xl font-bold">ユーザー一覧</h1>
    <Spreadsheet v-if="!isLoading" :key="spreadsheetKey" :tabs="false" :toolbar="false">
        <Worksheet :columns="columns" :data="data" />
    </Spreadsheet>
    <div class="mt-4">
        <button 
            @click="saveData" 
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
            :disabled="isSaving"
        >
            {{ isSaving ? '保存中...' : '保存' }}
        </button>
    </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import axios from 'axios'
// @see https://bossanova.uk/jspreadsheet/docs
import { Spreadsheet, Worksheet } from "@jspreadsheet-ce/vue";
import "jsuites/dist/jsuites.css";
import "jspreadsheet-ce/dist/jspreadsheet.css";

const isLoading = ref(true)
const isSaving = ref(false)
const spreadsheetKey = ref(0)
const columns = [
    { title: 'ID', type: 'text', width: 50, align: 'left', readOnly: true },
    { title: '名前', type: 'text', width: 150, align: 'left' },
    { title: 'メールアドレス', type: 'text', width: 300, align: 'left', readOnly: true },
    { title: '電話番号', type: 'text', width: 150, align: 'left' },
    { title: '携帯番号', type: 'text', width: 150, align: 'left' },
    { title: '住所', type: 'text', width: 300, align: 'left' },
    { title: '作成日時', type: 'text', width: 200, align: 'left', readOnly: true },
    { title: '更新日時', type: 'text', width: 200, align: 'left', readOnly: true }
]
const data = ref([])

const fetchData = async () => {
    try {
        const response = await axios.get('/api/users')
        
        // データを配列形式に変換
        const users = response.data.map(user => {
            return [
                user.id || '',
                user.name || '',
                user.email || '',
                user.phone_number || '',
                user.mobile_number || '',
                user.address || '',
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
}

const saveData = async () => {
    try {
        isSaving.value = true
        const users = data.value.map(row => ({
            id: row[0],
            name: row[1],
            email: row[2],
            phone_number: row[3],
            mobile_number: row[4],
            address: row[5],
            created_at: row[6],
            updated_at: row[7]
        }))
        
        await axios.patch('/api/users', { users })
        await fetchData()
        alert('保存が完了しました')
    } catch (error) {
        console.error('Error:', error)
        alert('保存に失敗しました')
    } finally {
        isSaving.value = false
    }
}

onMounted(async () => {
    isLoading.value = true
    await fetchData()
})
</script>
