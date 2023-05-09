<img src="https://capsule-render.vercel.app/api?type=Rounded&color=007bff&height=300&section=header&text=BlueCheck%20&fontSize=90&fontColor=ffffff" />

# BlueCheck
<p>✅ CheckList App ✅</p>
<p>개인 체크리스트로 자신을 관리하고 그룹간 체크리스트로 활동을 공유할 수 있는 어플입니다.</p>

<p><img src="https://img.shields.io/badge/16.0 + -007bff?style=flat&logo=iOS&logoColor=white">
<img src="https://img.shields.io/badge/Swfit -F05138?style=flat&logo=Swift&logoColor=white">
<img src="https://img.shields.io/badge/Firebase -FFCA28?style=flat&logo=Firebase&logoColor=white">
<img src="https://img.shields.io/badge/Lottie -FF5A5F?style=flat&logo=Airbnb&logoColor=white"></p>




## instead of Server
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
 
별도의 서버 구축 없이 서비스를 제공하기 위해서 파이어베이스의 제품들을 사용하였습니다.
 
- [Cloud Firestore](https://firebase.google.com/products/firestore?hl=ko)
  - Firestore를 이용해 최신 데이터를 저장,수정,삭제 할 수 있습니다.

- [Firebase Auth](https://firebase.google.com/docs/auth/ios/firebaseui?hl=ko)
  - Firebase Auth 를 통해 사용자 인증을 할 수 있습니다.
  
- [Firebase Storage](https://firebase.google.com/docs/storage/ios/start?hl=ko)
  - Firebase Storage를 통해 이미지를 관리 할 수 있습니다.
  
- [Firebase Dynamic Links](https://firebase.google.com/docs/dynamic-links/ios/receive?hl=ko)
  - Firebase Dynamic Links를 통해 이메일 인증 후 동적으로 앱을 열 수 있습니다.
  

## 구성
### 0. StartAnimationView (시작 애니메이션)
- 영상을 직접 제작해 JSON 형식으로 변환하고 로띠 라이브러리를 이용해 로딩시 애니메이션을 보여줄 수 있도록 하였습니다.
- 사용 프로그램: 애프터 이펙트, 포토샵, 일러스트, 로띠

  <img src="https://user-images.githubusercontent.com/96559947/236402747-f63631ef-d94e-4c6e-8dfc-326888e66c11.gif" width="200" height="400">

### 1. Auth (인증)

#### 회원가입
- 이메일을 이용해 회원가입할 수 있습니다.
- 이메일 인증을 반드시 해야 회원가입을 할 수 있도록 하였습니다.
- 이름, 닉네임 , 비밀번호를 입력하도록 하였습니다.

#### 아이디, 비밀번호 찾기
- 아이디 찾기 : 이름과 이메일을 통해 존재하는 아이디인지 여부를 확인할 수 있습니다.
- 비밀번호 찾기: 이름과 이메일 을 통해 작성한 이메일에 비밀번호 재설정메일을 보내 재설정할 수 있습니다.

#### 로그인
- 애플계정 및 BlueCheck 회원가입한 계정 으로 로그인할 수 있습니다.
- 자동로그인을 체크 후 로그인할 경우 자동으로 로그인 할 수 있습니다.
<p> <img src="https://user-images.githubusercontent.com/96559947/236405462-718595de-fe85-459b-82be-8e02dda7d71a.png" width="200" height="400">
 <img src="https://user-images.githubusercontent.com/96559947/236405630-5e31662e-41a4-468d-aea8-2c36183e947a.png" width="200" height="400">
 <img src="https://user-images.githubusercontent.com/96559947/236405717-f43b88c5-71d2-4066-a2e3-bedcbaa33b46.png" width="200" height="400">
 <img src="https://user-images.githubusercontent.com/96559947/236405775-374dabf8-0668-47d2-89a2-9abe97d00db6.png" width="200" height="400"></p>


### 2. BucketList (버킷리스트)
#### 자신의 한해 목표를 달성할 수 있도록 버킷리스트 기능을 제공합니다
- 추가 / 달성 / 삭제 / 수정
<p> <img src="https://user-images.githubusercontent.com/96559947/236406806-23d6a188-9ccd-4ba4-a894-55e6961c6b55.png" width="200" height="400">
 <img src="https://user-images.githubusercontent.com/96559947/236406902-30b2ed73-4fe7-4022-9953-bd2e8844d5ba.png" width="200" height="400">
 <img src="https://user-images.githubusercontent.com/96559947/236407012-955bd5f5-b1b2-4ae3-962a-278eca25cb74.png" width="200" height="400">
 
### 3. Calendar (달력)
달력을 활용하여 중요한 내용들을 기록할 수 있도록 하였습니다.
- 추가 / 달성 / 삭제 / 수정
 
 <p><img src="https://user-images.githubusercontent.com/96559947/236408335-64c2bb0a-1e32-4a04-9193-d791fdf031e9.png" width="200" height="400">
 <img src="https://user-images.githubusercontent.com/96559947/236408413-f2f325ad-6d35-46e0-ad2f-7eca9470c4e6.png" width="200" height="400">
 <img src="https://user-images.githubusercontent.com/96559947/236408493-2873a7ad-c657-47b3-8c5a-66310826021f.png" width="200" height="400"></p>
 
 ### 4. GroupList (그룹리스트)
그룹내 그룹원간 같은 목적을 달성하고 공유할 수 있습니다.

#### 그룹목록
- 속해 있는 그룹의 리스트를 한눈에 보여줍니다.
- 그룹 목적, 그룹명, 그룹 내용을 파악할 수 있습니다.
- 그룹을 추가할 수 있습니다.

#### 그룹 추가
- 그룹명, 목표, 구체적인 내용을 설정할 수 있습니다.

#### 그룹 인원 추가 리스트
- 그룹에 초대할 사람의 이름과 이메일 명단을 확인할 수 있습니다.
- 그룹에 초대할 명단에서 삭제버튼을 통해 제외할 수 있습니다.
- 초대할 인원을 검색하는 뷰로 이동할 수 있습니다.

#### 그룹 추가 인원 검색 
- 그룹에 초대할 계정을 이메일로 검색하고 초대할 수 있습니다.
- 이미 추가한 명단은 추가되었다고 메시지를 나타냅니다.
- 초대하기 버튼을 누를경우 그룹 인원 추가 리스트로 데이터를 전달하게 됩니다.

#### 각 그룹별 공유 기록
- 제목, 작성자, 이미지, 시작/종료 날짜, 내용, 수정/삭제 버튼으로 구성되어있습니다.
- 작성자로 닉네임을 보여주도록 하였습니다.
- 작성자가 본인이라면 글을 수정 및 삭제 할 수 있습니다.

#### 각 그룹별 공유 기록 추가
- 제목, 내용, 사진을 반드시 추가해야합니다.
- 사진은 5장까지 추가할 수 있습니다.
- 시작 / 종료 날짜를 설정할 수 있습니다.

<p>
<img src="https://user-images.githubusercontent.com/96559947/236411935-cecb6fad-5654-4d5f-a953-525b5bda12c2.png" width="200" height="400">
<img src="https://user-images.githubusercontent.com/96559947/236412016-e3d1e40c-fa45-410e-8fd1-12e838246723.png" width="200" height="400">
<img src="https://user-images.githubusercontent.com/96559947/236410922-dd3a2cc0-a119-42b5-969e-4ce7488088b3.png" width="200" height="400">
 <img src="https://user-images.githubusercontent.com/96559947/236410988-da0286a3-3865-4268-bb43-2081420da446.png" width="200" height="400">
 <img src="https://user-images.githubusercontent.com/96559947/236411062-370d3ea9-aaca-47b0-82dc-7c69369cc27a.png" width="200" height="400">
 <img src="https://user-images.githubusercontent.com/96559947/236411167-e47487e9-7e20-41b8-8989-a7d1336e034f.png" width="200" height="400">
 <img src="https://user-images.githubusercontent.com/96559947/236412231-7abf22eb-34dc-41cf-bb60-7615377c0f5f.png" width="200" height="400">
 <img src="https://user-images.githubusercontent.com/96559947/236411282-6f5269bc-7146-49d7-b195-4c4166475eed.png" width="200" height="400"></p>


### 5. ETC (그 외)
자신의 닉네임, 이메일을 보여주고 초대 현황 , 프로필 관리, 로그아웃, 회원탈퇴 기능을 가지고 있습니다.
#### 초대현황
- 다른 그룹에서 초대한 초대장을 통해 수락, 거절 할 수 있습니다.
#### 프로필 관리
- 닉네임을 변경할 수 있는 공간입니다.
- 닉네임을 10글자 이하로 만들도록 하였습니다.
#### 로그아웃
- 현재 로그인된 계정을 로그아웃합니다.
#### 회원탈퇴
- 현재 접속된 계정을 회원탈퇴합니다.
- 데이터는 사라지지 않습니다. (같은 이메일로 재가입시 전에 작성했던 내용을 확인할 수 있습니다.)
<p> <img src="https://user-images.githubusercontent.com/96559947/236414309-4c351bc5-a43e-4d57-805d-611ca61bf489.jpeg" width="200" height="400">
 <img src="https://user-images.githubusercontent.com/96559947/236414508-d24c6eae-ee84-4ad8-b373-8502e5a91f6c.jpeg" width="200" height="400">
<img src="https://user-images.githubusercontent.com/96559947/236414554-c6d8ba4a-701e-41c2-8f1d-887484f5fb5a.png" width="200" height="400">
<img src="https://user-images.githubusercontent.com/96559947/236414699-11aa82e5-8369-47dd-be24-e8245bd559ee.png" width="200" height="400">
<img src="https://user-images.githubusercontent.com/96559947/236414778-305e1142-798b-49b1-9ebf-e44e452ed3ba.png" width="200" height="400"></p>

  
## App Store
https://apps.apple.com/kr/app/%EB%B8%94%EB%A3%A8%EC%B2%B4%ED%81%AC/id6448659499
