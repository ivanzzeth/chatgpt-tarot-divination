import { ref } from "vue";
import {
    createGlobalState, useDark, useToggle, useLocalStorage
} from '@vueuse/core'

export const useGlobalState = createGlobalState(
    () => {
        const isDark = useDark()
        const toggleDark = useToggle(isDark)
        const loading = ref(false);
        const customOpenAISettings = useLocalStorage('customOpenAISettings', {
            enable: false,
            baseUrl: 'https://api.deepseek.com/v1',
            apiKey: '',
            model: 'deepseek-chat',
        });
        return {
            isDark,
            toggleDark,
            customOpenAISettings,
        }
    },
)
