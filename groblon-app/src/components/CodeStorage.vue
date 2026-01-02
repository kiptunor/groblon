<template>
  <CodeEditor
    v-model:value="code"
    :language="lang"
    :theme="theme"
    :height="950"
    :lifecycle="lifecycleHooks"
    @error="handleError"
    @ready="handleReady"
    @loading="handleLoading"
  />
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { CodeEditor, type EditorLifecycleHooks, type EditorError } from 'monaco-editor-vue3';



const lang = ref('cpp')
const theme = ref('vs-dark')



const code = ref(`#include <iostream>




int main()
{
  std::cout << "Hello, World!" << std::endl;
  return 0;
}`);

const editorError = ref<EditorError | null>(null);

// Lifecycle hooks
const lifecycleHooks: EditorLifecycleHooks = {
  beforeCreate: async () => {
    console.log('Editor will be created...');
  },
  onCreated: (editor) => {
    //console.log('Editor created:', editor);
    
    
    // Autosave logic
    let timeout: number
    let saveRefreshTimeout: number
    
    editor.onDidChangeModelContent(() => {
      clearTimeout(timeout)
      clearTimeout(saveRefreshTimeout)

      timeout = window.setTimeout(() => {
        console.log('SAVING CODE CONTENT:', editor.getValue())

       //server.save_note({
       //  filename: current_file_path.value,
       //  content: editor.getValue()
       //})

        //saveRefreshTimeout = window.setTimeout(() => {
        //  notesStore.fetchNotes()
        //}, 500)
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
