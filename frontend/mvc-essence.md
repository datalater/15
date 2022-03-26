# [MVC 창시자가 말하는, MVC의 본질](https://velog.io/@eddy_song/mvc)

> **🚀 TLDR**
>
> (동기) MVC는 GUI 소프트웨어를 설계할 때 UI 로직과 데이터 처리 로직을 분리하기 위해 만들어졌다. 왜냐하면 두 로직은 서로 특성이 다르고 변경하는 이유나 시점도 다르기 때문이다. (정리) MVC의 본질은 이렇듯 관심사의 분리이다. (장점) 관심사를 잘 분리하면 각자 맡은 부분만 신경쓰면 되므로 결합도가 낮아지고 중복이 줄어든다. 그러면 변경하기가 쉬워져서 결과적으로 좋은 코드가 된다. (한계) 하지만 애플리케이션이 더 복잡해지면서 MVC도 한계를 드러낸다. (맥락) 그래서 MVVM 같은 다른 아키텍처들도 나왔는데 결국은 이것도 모델과 뷰를 분리한다는 전제는 동일하다. 다만 예전보다 애플리케이션의 로직이 더 복잡해지다 보니, 그 복잡한 로직 안에서 다시 관심사의 분리를 잘 하기 위해 만들어진 것이다. 결국 관심사의 분리라는 본질은 같다.

(시작) MVC는 GUI 개발에서 시작되었다. GUI 개발을 설계할 때 중요한 것이 무엇일까?

> MVC의 창시자 트라이브 린스케이지(Trygve Reenskaug)는 GUI 개발을 보면서 한 가지 사실을 깨닫는다.
>
> 사용자가 세상을 인식하는 방법(멘탈 모델)과, 컴퓨터가 정보를 인식하고 처리하는 방법이 정말 다르네.
>
> 전혀 성질이 다른 이 두 부분을 잘 분리시켜서 설계하는 게 매우 중요하겠구나..!

(차이) UI 관련된 코드와 데이터 저장/처리 코드는 하는 일도 다르고 변경하는 이유나 시점도 매우 다르므로 분리해야 한다. 이를 MVC로 구조를 나누면 GUI를 가진 소프트웨어를 객체 지향적으로 잘 구조화할 수 있다.

> 트라이브가 GUI를 사용하는 애플리케이션을 잘 보니, 'UI 관련된 코드'와 '데이터 저장/처리 코드'는 특성과 하는 일이 뚜렷하게 달랐다. 변경하는 이유나 시점도 무척 달랐다.
>
> 트라이브는 (1) '비즈니스 로직'과 (2) '시각적인 UI' (3) 둘 사이를 연결해주는 부분을 코드 안에서 분리하고 역할 부여를 해줘야 한다는 생각을 하게 된다.
>
> GUI를 사용하는 애플리케이션을 객체 지향적으로 추상화하려고 하니까, 객체들이 맡고 있는 '역할'을 나눠주는 게 무척 중요할 거 같다 이 말이야...
>
> 그렇다면 역할을 이렇게 나눠보면 어떨까.
>
> - 애플리케이션 데이터를 저장/가공하는 역할을 Model.
> - 화면에 데이터를 표시하고, 사용자와의 인터랙션을 담당하는 부분을 View.
> - 둘을 연결하는 역할을 Controller.
>
> 이렇게 나눠서 Model - View - Controller로 분류(추상화)하면 어떻겠나?

![MVC 초기아이디어](https://miro.medium.com/max/700/1*6NUTfvsDJfoBSfp9wuT7FQ.png)

<div style="display: flex; flex-direction: column; justify-content: center; align-items: center;">
  <em style="display: block; text-align: center; font-style: normal; font-size: 80%; padding: 0; color: #6d6c6c;" aria-label="caption">MVC 초기 아이디어</em>
</div>

(질문) MVC의 본질은 무엇일까? 관심사의 분리다.

> 'Model과 View를 분리하는 것'이다.
>
> "At the heart of MVC, and the idea that was the most influential to later frameworks, is what I call Separated Presentation."
>
> "The idea behind Separated Presentation is to make a clear division between domain objects that model our perception of the real world, and presentation objects that are the GUI elements we see on the screen."
> -Martin Fowler

(질문) 그럼 관심사를 분리하면 뭐가 좋을까? 각자 맡은 부분만 신경쓰도록 코드를 분리하면 서로 결합도가 낮아지고 코드의 중복을 줄일 수 있다. 그러면 변경하기가 쉬워진다.

> 소프트웨어도 마찬가지다. 묶어놓은 코드(모듈)들의 역할을 나누고, 각자 맡은 부분만 신경쓰는 것이 기본 원리다. 그래야만 서로가 서로에게 영향을 받지 않고, 코드의 중복을 줄일 수 있다. 결합도가 낮아지고 중복이 줄어들면 변경을 하기가 쉬워진다. 변경을 하기가 쉬우면? 좋은 코드가 될 가능성이 높다.

(문제점) MVC 구조도 상황에 따라서 문제점이 있다. 역할 분배가 너무 단순하다. 그래서 모델(Model)과 뷰(View)를 제외한 나머지 일들이 모두 컨트롤러(Controller)에게 몰리게 되는 경우가 많다. 그러면 결국 컨트롤러 내부에서 관심사의 분리가 제대로 안 지켜지게 된다.

> iOS에서는 MVC 외에도 MVVM, MVP, VIPER, RIBs 등이 유명하다. 이 아키텍처도 결국은 복잡한 앱을 만들어야 하는데 MVC만으로 부족하니까 추가적인 역할을 부여하면서 진화해나간 버전이다.
>
> M과 V의 분리라는 기본 원칙에서 시작해서, 더 복잡한 것들을 하기 위해 진화했다. (다르게 말하면, 별로 안 복잡한 앱은 MVC로 해도 얼마든지 상관없다는 뜻이기도 하다.)
