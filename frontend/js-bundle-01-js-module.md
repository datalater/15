# [JavaScript 번들러의 이해 — (1) JavaScript 모듈](https://medium.com/naver-place-dev/javascript-%EB%B2%88%EB%93%A4%EB%9F%AC%EC%9D%98-%EC%9D%B4%ED%95%B4-1-javascript-%EB%AA%A8%EB%93%88-d68c7e438fcd)

## 번들러가 등장한 이유

> 🚀 **TL;DR**
>
> (동기) 대규모 애플리케이션 개발을 하려면 관심사의 분리가 필요하고 가장 간단한 구현 방식이 파일을 쪼개는 모듈화입니다. (문제점) 그런데 여러 개로 쪼개진 JS 파일을 HTML에서 쪼개진 수만큼 불러오는 것은 (1) JS 파일간 의존성 문제 (2) HTTP 요청 수 증가에 따른 서버 부담 증가와 스크립트 로드 시간 증가 (3) JS 파일간 이름 충돌 문제가 있습니다. (등장배경) 이러한 문제를 해결하기 위해 스크립트를 한 파일로 만드는 번들링이라는 개념이 등장합니다.

모듈 개념이 없던 JS에 모듈 개념이 등장한 이유

> (현상) 초기 JS에서는 모듈이라는 개념이 없었습니다. (한계) 그러나 대규모 애플리케이션 개발에서 모듈 개념은 필수적입니다. 왜냐하면 관심사 분리는 늘 필요하고 관심사 분리를 구현하는 가장 쉬운 방법이 파일을 쪼개는 것이기 때문입니다. (등장배경) JS에도 모듈 개념이 등장합니다.

<details markdown="1">
<summary><strong>code</strong></summary>

```html
<html>
  <head></head>
  <body>
    <script src="./utilities.js"></script>
    <script src="./vector.js"></script>
    <script src="./main.js"></script>
  </body>
</html>
```

```js
// main.js

var v0 = new Vector(2);
var v1 = new Vector(2);
var v2 = v0.add(v1);
```

```js
// utilities.js

function add(x, y) { ... }
```

```js
// vector.js

function Vector(size) {
  this.size = size;
  this.data = new Array(size);
}
Vector.prototype.add = function (v) {
  var result = new Vector(this.size);
  for (var i = 0; i < this.size; ++i) {
    result[i] = add(this.data[i], v.data[i]);
  }
  return result;
};
```

</details>

여러 개로 쪼개진 JS 파일을 HTML에서 쪼개진 수만큼 불러오면 발생하는 문제

> (문제점) 그러나 JS 파일을 여러 개로 쪼개서 HTML 파일에서 여러 개의 JS 파일을 불러오는 방식은 문제점이 있습니다. (1) HTML 파일에서 JS 파일의 의존성을 수동으로 잡아줘야 합니다. 왜냐하면 JS 파일이 서로 어떻게 의존하느냐에 따라 HTML에서 JS 파일을 불러오는 순서가 중요하기 때문입니다. (2) 늘어나는 JS 파일의 개수만큼 HTTP 요청이 증가합니다. HTTP 요청이 증가하면 오버헤드가 커서 서버에 부담을 주며 스크립트 로드 시간도 증가되어 사용자 경험에도 불리합니다. (3) 라이브러리 간 함수나 변수 같은 이름 충돌(namespace collision)이 발생할 수 있습니다.
>
> (맥락) 이름 충돌 해결을 위해 즉시실행함수(IIFE)를 활용해서 전역객체에 묶어서 내보내는 방식이 등장했습니다.

<details markdown="1">
<summary><strong>code</strong></summary>

```js
// main.js

var v0 = new vectorModule.Vector(2);
var v1 = new vectorModule.Vector(2);
var v2 = v0.add(v1);
```

```js
// vector.js

(function (scope) {
  function Vector(size) {
    this.size = size;
    this.data = new Array(size);
  }

  Vector.prototype.add = function (v) {
    var result = new Vector(this.size);
    for (var i = 0; i < this.size; ++i) {
      result[i] = this.data[i] + v.data[i];
    }
    return result;
  };

  scope.vectorModule = {
    Vector: Vector,
  };
})(window);
```

</details>

번들링 개념이 탄생한 배경

> (등장배경) 이후 스크립트를 한 파일로 만드는 번들링(bundling)이라는 개념이 탄생합니다. (해결방식) 번들링은 의존성을 자동으로 분석하여 번거로움을 덜어주고, 파일을 하나로 합쳐 HTTP 요청도 줄입니다.

## 번들러를 이해하려면 JS 모듈의 역사를 알아야 한다

> 🚀 **TL;DR**
>
> CommonJS
>
> - `require()` 함수와 `module.exports`를 사용합니다.
> - ECMA 표준이 아니므로 브라우저에서 사용할 수 없습니다.
>
> AMD(Asynchronous Module Definition)
>
> - `define()` 함수를 사용합니다.
> - CJS 논의 당시 비동기 처리에 대한 합의점을 찾지 못한 개발자들이 따로 나와서 콜백 방식을 제안한 규격입니다.
>
> UMD(Universal Module Definition)
>
> - CJS와 AMD를 모두 지원하기 위해 나온 규격입니다.
>
> ESM(ECMAScript Module)
>
> - ECMA 표준이므로 `<script type="module">`를 명시하면 브라우저에서 사용할 수 있습니다.

CJS: CommonJS

> (개념) CJS는 `require()` 함수와 `module.exports`를 사용하는 규격으로 대표적인 구현체로 NodeJS가 있습니다. ECMA2015가 등장하기 전까지는 사실상 표준이었지만 CJS는 ECMA 표준이 아니므로 브라우저에서 사용할 수 없습니다. (예시) 예를 들어, 브라우저 개발자 도구 콘솔에서 `exports` 객체를 찾을 수 없다는 에러가 뜬다면 CJS 모듈이 번들링되지 않은 상태로 브라우저에서 로드되었다는 뜻입니다.

<details markdown="1">
<summary><strong>code</strong></summary>

```js
// main.js
const Vector = require("./vector.js");
var v0 = new Vector(2);
var v1 = new Vector(2);
var v2 = v0.add(v1);
```

```js
// vector.js
const { add } = require('./utilities.js')
function Vector {
  ...
}
module.exports = Vector
```

</details>

AMD: Asynchronous Module Definition

> (배경) AMD는 CJS 논의 당시 비동기 처리에 대한 합의점을 찾지 못한 개발자들이 따로 나와서 만든 규격입니다. [`define()` 함수](https://github.com/amdjs/amdjs-api/wiki/AMD#api-specification)를 사용합니다. (작동방식) 이들은 콜백을 활용한 기법을 제안했고 CJS로 제작된 모듈도 쉽게 AMD로 변환 가능합니다. 대표적인 구현체로 RequireJS가 있고 [jQuery 초기버전](https://github.com/jquery/jquery/blob/1.12-stable/src/core.js)에서도 흔적이 남아 있습니다. AMD는 결국 사라졌지만 후술할 UMD에 흔적을 남기게 됩니다.

<details markdown="1">
<summary><strong>code</strong></summary>

```js
define(["require", "exports", "add"], function (require, exports, add) {
  "use strict";
  Object.defineProperty(exports, "__esModule", { value: true });
  exports.Vector = void 0;
  class Vector { ... }
  exports.Vector = Vector
})
```

</details>

UMD: Universal Module Definition

> (배경) UMD는 CJS와 AMD 시스템을 모두 지원하기 위해 나온 규격입니다. 코드가 복잡해보이지만, 윗 부분은 런타임 환경을 인식한 뒤 규격에 맞게 분기하는 내용이며, 아랫 부분은 AMD와 동일합니다.

<details markdown="1">
<summary><strong>code</strong></summary>

```js
// vector.js

(function (factory) {
  if (typeof module === "object" && typeof module.exports === "object") {
    var v = factory(require, exports);
    if (v !== undefined) module.exports = v;
    else if (typeof define === "function" && define.amd) {
      define(["require", "exports"], factory);
    }
  }
})(function (require, exports) {
  "use strict";
  Object.defineProperty(exports, "__esModule", { value: true })
  exports.Vector = void 0;
  function Vector(size) { ... }
  exports.Vector = Vector
});
```

</details>

ESM: ECMA Script Module

> (개념) ECMA2015(ES6) 표준에 드디어 모듈이 등장합니다. `import`와 `export` 구문을 사용합니다. 모던 브라우저라면 `<script type="module">`을 명시해주기만 하면 바로 사용할 수 있습니다. (특징) ESM은 간결함이 특징인 규격으로, CJS와 다르게, `export/import`를 통해 객체(Object)만 내보낼 수 있으며, 함수처럼 호출(ex. `require('./vector.js')`)할 수 없다는 특징이 있습니다. 또한 `default export`는 내보내는 값에 제약이 없지만, 파일당 하나만 가능하다는 조건이 있습니다.

<details markdown="1">
<summary><strong>code</strong></summary>

```js
// example.js

// export
export class Vector { ... }
export default Foo

// import
import { add } from './utilties'
import Foo from './defaultExportedModule'
```

</details>

> CJS 진영인 NodeJS 역시 13.2 버전부터 실험적으로 ESM을 지원하기 시작했습니다.
