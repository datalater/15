# [Should I Use Vue 3 or Vue 2 In 2022?](https://javascript.plainenglish.io/should-i-use-vue-3-or-vue-2-in-2022-ba09c8059233)

(목록) Vue3에서 소개된 새로운 기능 목록

> - Composotion API
> - Global mounting/configuration API change
> - Fragments
> - Suspense
> - Multiple v-models
> - Portals
> - New custom directives API

(문제) Composition API는 기존에 사용하던 Option API의 문제를 해결한다. Option API의 문제는 그대로 동작하는 자바스크립트 코드가 아니다 보니 내부 동작이 뷰 컴파일 단계에서 숨겨져 있고, 템플릿에서 사용할 수 있는 속성이 무엇인지 정확히 알아야 하며 this 바인딩의 행동 또한 정확하게 예측해야 하는 문제점이 있다. Composition API는 일반적인 자바스크립트 함수를 사용하여 문제를 해결한다. 왜냐하면 자바스크립트 함수 코드는 숨겨진 내부 동작이 따로 없기 때문에 그 자체로 읽기만 해도 어떤 속성을 사용할 수 있는지 바로 알 수 있기 때문이다.

> Option API는 `data`, `methods`, `computed` 같은 속성을 사용한다. 그런데 이 접근법의 가장 큰 단점은 그대로 동작하는 자바스크립트 코드가 아니라는 점이다. `this` 바인딩을 명확히 이해해야 하고 템플릿에 사용할 수 있는 속성이 어떤 속성인지 정확히 알아야 하며, 뷰 컴파일러가 해당 속성을 동작하는 코드로 변환한다는 것도 알아야 한다.
>
> Composition API는 이 문제를 해결한다. 어떻게 해결하냐면, 현재 사용할 수 있는 속성이 무엇인지 자바스크립트의 함수로 분명하게 드러낸다. 일반적인 자바스크립트 코드를 읽기만 해도 어떤 속성을 템플릿에서 사용할 수 있는지 명확히 알 수 있다.

```vue
<template>
  <button @click="increment">
    Count is: {{ count }}, double is {{ double }}, click to increment.
  </button>
</template>

<script>
import { ref, computed, onMounted } from "vue";

export default {
  setup() {
    const count = ref(0);
    const double = computed(() => count.value * 2);
    function increment() {
      count.value++;
    }
    onMounted(() => console.log("component mounted!"));
    return {
      count,
      double,
      increment,
    };
  },
};
</script>
```

(장점) Composition API의 또 다른 장점은 코드의 재사용성을 높인다는 점이다.

> 현재는 코드를 다른 컴포넌트에서도 재사용하려면 mixin을 사용하거나 scoped slots를 사용해야 한다. 둘 다 각각 단점이 있다.
>
> 믹스인(mixin)의 가장 큰 단점은 컴포넌트에 추가한 게 실제로 무엇인지 알 수 없다는 점이다. 추가하는 코드만 봐서는 어떤 동작을 하는 코드가 추가되는 건지 드러나지 않기 때문이다. 또한 사용하려는 컴포넌트에 이미 존재하는 이름과 충돌할 수 있는 이름 충돌 문제도 있다.

```vue
<script>
import CounterMixin from "./mixins/counter";

export default {
  mixins: [CounterMixin],
};
</script>
```

> 스코프 슬롯(scoped slot)은 어떤 속성을 사용할 수 있는지 코드를 보면 알기 쉽다. 하지만 가장 큰 단점은 하나의 `template`에서만 접근할 수밖에 없다는 것과 `Counter` 컴포넌트 스코프에서만 사용할 수 있다는 것이다.

> 컴포지션 API를 사용하면 다음과 같다. 어떤 기능이 추가되는지 코드에서 드러나며 다양한 컴포넌트에서 재사용이 가능하다.

```vue
<script>
function useCounter() {
  const count = ref(0);
  function increment() {
    count.value++;
  }
  return {
    count,
    incrememt,
  };
}
export default {
  setup() {
    const { count, increment } = useCounter();
    return {
      count,
      increment,
    };
  },
};
</script>
```

## 📚 함께 읽기

- [Vue Composition API FAQ](https://vuejs.org/guide/extras/composition-api-faq.html)
