# [[번역] Vue의 반응성 시스템은 당신의 생각보다 더 강력합니다](https://velog.io/@jonghunbok/%EB%B2%88%EC%97%AD-Vue%EC%9D%98-%EB%B0%98%EC%9D%91%EC%84%B1-%EC%8B%9C%EC%8A%A4%ED%85%9C%EC%9D%80-%EB%8B%B9%EC%8B%A0%EC%9D%98-%EC%83%9D%EA%B0%81%EB%B3%B4%EB%8B%A4-%EB%8D%94-%EA%B0%95%EB%A0%A5%ED%95%A9%EB%8B%88%EB%8B%A4)

> 🚀 **TL;DR**
>
> Vue를 사용하면 `ref`라는 반응성 API를 사용하여 쉽게 상태 관리자를 만들 수 있다. 유즈 케이스가 복잡하거나 규모 있는 앱에서는 `Pinia`나 `Vuex` 같은 상태 관리 라이브러리를 사용한다.

(비교) 프론트엔드 개발은 데이터를 잘 보여주면 된다. 바닐라 자바스크립트를 이용해서 로직을 구현할 수도 있지만, 불편한 점이 있다.

> 바닐라 자바스크립트를 이용해 로직을 구현하는 것도 괜찮습니다. 하지만 어떤 콜백이나, 조건, 이벤트가 발생했을 때 동적인 데이터를 화면에서 업데이트하게 되면 이야기가 달라집니다.
>
> 바닐라 자바스크립트를 사용하면 보일러 플레이트 코드가 많이 필요합니다. DOM이 준비되길 기다려야 하고, DOM 컴포넌트를 쿼리해야 하고, `onclick` 이벤트 핸들러를 구성해야 하고, 그러고 나서 이벤트가 발생할 때 직접 뷰(view)를 업데이트 해야 합니다.

(정의) 컴포넌트는 다음 세 가지 요소를 가진다.

> - 상태: 앱을 구동시키는 데이터 저장소
> - 뷰(view): 상태의 선언적 맵핑
> - 액션: 뷰에서 일어나는 사용자의 입력에 대한 반응으로 상태를 바꿀 수 있는 방법

(장점) Vue의 반응성 API를 활용하면 글로벌 상태 관리를 쉽게 구현할 수 있다. 다수의 컴포넌트 인스턴스에서 공유해야 하는 상태가 있다면, `ref`로 반응형 객체를 만들고, 이를 여러 컴포넌트에서 가져와서 사용하면 된다.

> `store` 인스턴스를 만든다.

```ts
// store.ts
import { ref } from "vue";

export const store = ref({
  count: 0,
  increment() {
    this.count++;
  },
});
```

> 다른 컴포넌트에서 `store`를 사용한다.

```vue
<!-- ComponentA.vue -->

<script setup lang="ts">
import { store } from "./store";
</script>

<template>
  <button @click="store.increment()">From A: {{ store.count }}</button>
</template>
```

```vue
<!-- ComponentB.vue -->

<script setup lang="ts">
import { store } from "./store";
</script>

<template>
  <button @click="store.increment()">From B: {{ store.count }}</button>
</template>
```

> 어디서 `store`가 변경되었든 간에 `ComponentA`와 `ComponentB`는 뷰(view)를 자동으로 업데이트한다. 단일 데이터 저장소(single cource of truth)가 생긴 것이다.
>
> 버튼의 클릭 핸들러에 store.increment()처럼 괄호를 넣은 것을 주목하세요. 컴포넌트의 메소드가 아니기 때문에, 적절한 this 컨텍스트를 가지고 메소드를 호출하기 위해 반드시 괄호가 필요합니다.

(주의) 간단한 시나리오에서는 위 예제처럼 반응성 API만으로도 상태관리를 할 수 있지만 규모 있는 프로덕션 애플리케이션에서는 고려할 게 많아 `Pinia`나 `Vuex` 같은 Vue의 상태관리 라이브러리를 사용한다.

> 규모 있는 프로덕션 애플리케이션에서 고려해야 할 것들:
>
> - 팀 협업을 위한 더 강력한 컨벤션
> - 타임라인, 컴포넌트 탐색, 시간여행 디버깅 등을 위한 Vue DevTools와의 연계
> - HMR (Hot Moduile Replacement)
> - 서버 사이드 렌더링 지원
>
> Pinia는 위 니즈를 모두 충족하는 상태 관리 라이브러리입니다. Vue 코어 팀이 관리하며 Vue2와 Vue3 모두 호환됩니다.
