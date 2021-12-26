<h1 align="center" style="display: block; font-size: 2em; font-weight: bold; margin-block-start: 1em; margin-block-end: 1em;">
<img align="center" src="https://user-images.githubusercontent.com/91931949/147404542-a8ef9abd-8feb-4035-91a8-8836a2b0dc4e.png" style="width:100%;height:100%"/>
<!--   <br><br><strong> picture replaced </strong> -->
</h1>

---

## Introduction
- Kaggle의 대표 문제인 'Bike Sharing Demand'을 **대한민국 서울형 Prediction**으로 변형했습니다. 
- 각 대여소와 날씨 등을 고려하여, 해당 대여소의 **일별 자전거 수요량을 예측하는 다중회귀 모델링**을 수행합니다.
- 사용 기술 : **SQL, Python(Pandas, Seaborn, Scikit-learn), AWS RDS**

---

## Contents
- [프로젝트 소개](#1-프로젝트-소개)
  * [배경](#배경)
  * [프로젝트 개요](#프로젝트-개요)
- [상세 내용](#2-상세-내용)
  * [Database - AWS](#db-aws)
  * [탐색적 데이터 분석(EDA)](#eda)
  * [모델링](#모델링)

---

## 1. 프로젝트 소개

### 배경
- 서울시 공유자전거 따릉이는 대중화되었지만, **수급 문제**가 발생하고 있습니다. (Ex. 따릉이 정류소에 따릉이가 없는 문제)
- **대여소, 날씨에 따른 수요량을 예측하는 회귀모델**을 개발, 서울시 따릉이 담당자의 의사결정을 지원하고자 합니다.
- [캐글(Kaggle) 'Bike Sharing Demand' 문제](https://www.kaggle.com/c/bike-sharing-demand)를 변형하여 프로젝트를 진행했습니다.

### 프로젝트 개요
1. 프로젝트명 : **Next Spring Prediction - Bicycle Sharing in Seoul**
2. 수행자 : 이민호 (Luke Lee)
3. 수행기간 : 4주 (2021. 12월 중)
4. 목표 : 내년 봄(3월 ~ 5월) 기준 대여소별 날씨에 따른 **일 예상 수요량**을 제시
5. 모델 내용 : Regression (Target : 일 대여 수, Feature : 대여소, 요일, 날씨)
6. 데이터셋 : 공공 데이터 활용, 2021년 3 ~ 5월 데이터
    |데이터명|상세 내용|
    |---|---|
    |Facility|공공자전거 대여소 정보|
    |User|공공자전거 대여이력 정보(March ~ May, 2021)|
    |Weather|일별 서울시 기상정보(March ~ May, 2021)|
  
---
  
## 2. 상세 내용

### DB-AWS
- **Amazon Web Service (RDS)** 상에 MySQL 환경의 데이터베이스를 구축했습니다. 
- bicycle_spring_2021(Database) > Facility, User, Weather(Table)
- **Python 환경**에서 AWS 연결하여, **Data Bulk Insert** 수행
```
pip install mysql
pip install sqlalchemy
```

### EDA
- 서울 따릉이 대여소는 총 2,414개이며 데이터는 208,477개로, 상세 시각화는 5개소를 지정했습니다.
- 강남역 부근 5개 대여소(**VIEW - Gangnam_stops**)를 지정하여 데이터를 분석했습니다.
- 아래와 같이 상세 시각화 및 분석 자료 중 주요 포인트를 정리했습니다.

#### Main Point:
:pushpin:**5개 대여소별 대여 건수** : 대여소별 대여 건수에 차이가 있는 것으로 나타났습니다.
<p float="left">
  <img src="https://user-images.githubusercontent.com/91931949/147408684-0adbfb7d-b701-4b87-85f1-f16a8f6446ff.png" width="400" />
</p>

:pushpin:**요일별 대여 건수** : 평일이 주말(토, 일)보다 대여 건수가 많은 것을 알 수 있습니다.
<p float="left">
  <img src="https://user-images.githubusercontent.com/91931949/147408702-332b1e14-d1d6-49a1-bb4a-e07198492e57.png" width="400" />
</p>

:pushpin:**날씨별 대여 건수 차이** : 대여 건수가 각 날씨 특성(8가지)의 영향을 많이 받는 것을 알 수 있습니다.
<p float="left">
  <img src="https://user-images.githubusercontent.com/91931949/147408759-43b99538-42fe-4160-876a-06ff06ecc296.png" width="1000" />
</p>


### 모델링
#### 데이터 추가 전처리
:pushpin:**Log Transformation**
- 타겟(Target)인 **대여 건수**의 분포 모양이 심각한 비대칭 형태로 나타나며, **Log Transform**을 수행했습니다.
    |기존 대여 건수 분포 형태|Log Transformation 후 분포 형태|
    |:--:|:--:|
    |![image](https://user-images.githubusercontent.com/91931949/147408945-76e80083-f3be-4268-a8b2-f5c59ad8c7e9.png)|![image](https://user-images.githubusercontent.com/91931949/147408956-ea4022ac-1fcb-43c7-ac38-34fd90894d7e.png)|
:pushpin:**One Hot Encoding**
- 범주형 특성(Categorical Features)인 **대여소, 요일**에 대하여 **One Hot Encoding**을 수행했습니다.

#### 모델링 결과
- Linear Regression, Lasso(alpha=0.01), Ridge(alpha=0.01), ElasticNet(alpha=0.01, l1_ratio=0.01)
    |Model|R-Squared|MSE|
    |:--:|:--:|:--:|
    |**Linear Regression**|**0.8460633603652339**|**0.14347345660668245**|
    |Lasso|0.6683860663241563|0.30907389843182687|
    |Ridge|0.8462325812094348|0.1433157378237793|
    |ElasticNet|0.846102709654883|0.143436781916275|

