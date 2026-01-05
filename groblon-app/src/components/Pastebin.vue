<template>
  <v-card>
    <v-toolbar color="primary-light">
      <v-div class="mr-2"></v-div>
      <v-btn
        class="mr-3"
        icon="mdi-dots-vertical"
        size="small"
        variant="elevated"
      >
        <v-icon></v-icon>
        <v-speed-dial activator="parent" :location="dialLocation" open-on-hover>
          <v-btn
            v-for="(item, i) in dialActionsReversed"
            :key="i"
            v-tooltip="{ location: tooltipLocation, text: item.tooltip, color: 'primary' }"
            :color="item.color"
            :icon="item.icon"
            @click="onDialAction(item, i)"
          ></v-btn>
        </v-speed-dial>
      </v-btn>
      
      <!--<v-text-field class="mt-6" style="max-width: 300px; width: 100%;" label="Search text" variant="solo-filled"></v-text-field>-->
      
      <v-btn
        color="grey-500"
        variant="elevated"
        v-tooltip:bottom="'Note properties'"
        class="ml-3"
        icon="mdi-information-slab-box"
      ></v-btn>
    </v-toolbar>
      <CodeEditor
        :key="current_file_path"
        v-model:value="monacoCtrl.code"
        :language="computedLang"
        :theme="theme"
        :path="current_file_path"
        :height="850"
        :lifecycle="lifecycleHooks"
        @error="handleError"
        @ready="handleReady"
        @loading="handleLoading"
      />
  </v-card>
  
  <div class="pa-4 text-center">
    <v-dialog
      v-model="pastebinDialog"
      max-width="600"
    >
      <v-card
        prepend-icon="mdi-text-box"
        title="Create pastebin"
      >
        <v-card-text>
          <v-text-field
            v-model="pastebinName"
            label="Name"
            required
            :rules="noteNameRule"
            variant="solo-filled"
          ></v-text-field>
        </v-card-text>

        <v-divider></v-divider>

        <v-card-actions>
          <v-spacer></v-spacer>

          <v-btn
            text="Cancel"
            variant="plain"
            @click="pastebinDialog = false"
          ></v-btn>

          <v-btn
            color="primary"
            :disabled="!pastebinName"
            text="Create"
            variant="tonal"
            @click="createPastebin()"
          ></v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, shallowRef, watch, computed, nextTick } from 'vue';
import { CodeEditor, type EditorLifecycleHooks, type EditorError } from 'monaco-editor-vue3';
// import * as monaco from 'monaco-editor'
import { server } from '../api/server'
import { useUI, usePastebinStore } from '@/stores/ui';
import { monacoControl } from '@/stores/Pastebin';
import { debounce } from 'lodash'








const pasteBin = usePastebinStore()
const ui = useUI()
const monacoCtrl = monacoControl()





const pastebinDialog = shallowRef(false)
const pastebinName = ref('')

const langMap: Record<string, string> = {
  js: 'javascript',
  ts: 'typescript',
  cpp: 'cpp',
  c: 'c',
  h: 'c',
  hpp: 'cpp',
  py: 'python',
  json: 'json',
  html: 'html',
  css: 'css',
  cs: 'csharp',
  java: 'java',
}

const current_file_path = ref<string | null>(null)
const editorRef = ref<InstanceType<typeof CodeEditor> | null>(null)

watch(
  () => ui.selected,
  (newVal) => {
    if (!newVal || newVal.length === 0) {
      return
    }
    current_file_path.value = newVal[0]
  },
  { immediate: true }
)

const computedLang = computed(() => {
  console.log('computedLang called')
  const ext = current_file_path.value?.split('.').pop()?.toLowerCase()
  return ext && langMap[ext] ? langMap[ext] : 'plaintext'
})

const dialActions = [
  { color: 'info-darken-1', icon: 'mdi-plus', tooltip: 'Create pastebin' },
  { color: 'red', icon: 'mdi-minus', tooltip: 'Remove pastebin' },
  { color: 'primary', icon: 'mdi-refresh', tooltip: 'refresh pastebin list' },
]

const dialActionsReversed = [...dialActions].reverse()


function onDialAction(item, index) {
  if (item.icon === 'mdi-plus') {
    pastebinName.value = ''
    pastebinDialog.value = true
  }
  if (item.icon === 'mdi-minus') {
    server.delete_file(current_file_path.value)
    pasteBin.fetchFiles()
  }
  if (item.icon === 'mdi-refresh') {
    pasteBin.fetchFiles()
  }
}

function createPastebin() {
  pastebinDialog.value = false
  server.create_pastebin(pastebinName.value)

  pasteBin.fetchFiles()
}


// Monaco stuff


const theme = ref('vs-dark')



const code = ref(``);

const editorError = ref<EditorError | null>(null);

// Lifecycle hooks
const lifecycleHooks: EditorLifecycleHooks = {
  beforeCreate: async () => {
    console.log('Editor will be created...');
  },
  onCreated: (editor) => {
  
    editorRef.value = editor
    
    // Autosave logic
    let timeout: number
    let saveRefreshTimeout: number
    
    editor.onDidChangeModelContent(() => {
      clearTimeout(timeout)
      clearTimeout(saveRefreshTimeout)

      timeout = window.setTimeout(() => {
       
       server.save_text_file({
         filename: current_file_path.value,
         content: editor.getValue()
       })

        saveRefreshTimeout = window.setTimeout(() => {
          pasteBin.fetchFiles()
        }, 500)
      }, 1000)
    })
  },
  onReady: (editor) => {
    console.log('Editor is ready');
  },
  onError: (error) => {
    console.error('Lifecycle error:', error);
  }
};

const handleError = (error: EditorError | null) => {
  editorError.value = error;
  if (error) {
    console.error('Editor error:', error);
  }
};

const handleReady = () => {
  console.log('Editor is ready for use');
};

const handleLoading = (loadingState: any) => {
  console.log('Loading state');
};
</script>