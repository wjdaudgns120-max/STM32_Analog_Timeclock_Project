# STM32 Analog Clock (Team 6)

STM32F411RE와 **스텝 모터 3개(시·분·초침)** 로 만든 아날로그 시계입니다.
DS3231 RTC의 시간을 실제 바늘 위치로 바꿔 움직이고, 스톱워치 모드에서는 같은 바늘로 경과 시간을 보여 줍니다. 시간과 날짜는 I2C LCD에도 함께 표시됩니다.

> 4인 팀 프로젝트 (2026.10)
> **담당: 스텝 모터 드라이버와 바늘 구동 로직, RTC 초 단위 동기화** (PR #4, #5)

## 주요 기능

| 모드 | 동작 |
|---|---|
| 시계 | DS3231 RTC 시간에 맞춰 시·분·초침 구동, LCD에 시간과 날짜 표시 |
| 스톱워치 | 같은 바늘로 스톱워치 시간 표시, LCD에 `SW:hh:mm:ss:ms` 표시 |

버튼(PC0)을 누를 때마다 두 모드가 전환됩니다.

## 바늘 구동 방식 (담당 파트)

### 1. 시간 → 목표 위치 계산
한 바퀴(28BYJ-48 하프스텝 기준 4096 스텝)를 각 바늘의 주기로 나누고, **한 단계 아래 단위까지 반영**해서 목표 위치가 연속으로 변하게 했습니다. 그래서 바늘이 1초·1분 단위로 툭툭 끊기지 않고 부드럽게 움직입니다.

```c
uint32_t centiSec = sec * 100 + msec;          // 60초에 1바퀴
uint32_t minSec   = min * 60 + sec;            // 60분에 1바퀴
uint32_t hourMin  = (hour % 12) * 60 + min;    // 12시간에 1바퀴

StepMotor_setTarget(&motor_sec,  centiSec * STEPS_PER_REV / 6000);
StepMotor_setTarget(&motor_min,  minSec   * STEPS_PER_REV / 3600);
StepMotor_setTarget(&motor_hour, hourMin  * STEPS_PER_REV / 720);
```

### 2. 목표 추종 (`StepMotor_task`)
- 각 모터는 현재 위치(`position`)와 목표 위치(`target`)를 가지고, 한 번 호출될 때마다 목표 쪽으로 한 스텝씩 움직입니다.
- 평소에는 10ms 간격으로 따라가고, 모드 전환처럼 목표와 1초 이상 벌어지면 3ms 간격으로 빠르게 따라잡습니다.

### 3. 타이머 인터럽트에서 구동
메인 루프는 LCD 출력 때문에 느려서, 스텝 구동을 **TIM2 1ms 인터럽트**로 옮겼습니다. LCD 갱신과 관계없이 세 모터가 일정한 속도로 움직입니다.

| 타이머 | 역할 |
|---|---|
| TIM2 (1ms) | 스텝 모터 3개 구동 |
| TIM3 | 디스플레이 갱신 |
| TIM4 | 시계·스톱워치 카운트 |

## 트러블슈팅: 빠른 추종 시 스텝 모터 탈조

- **현상**: 모드 전환 등으로 바늘이 목표 위치를 빠르게 따라잡을 때, 모터가 스텝을 놓쳐(탈조) 바늘 위치가 실제 시간과 어긋남
- **원인**: 빠른 추종 간격(`STEP_FAST_DELAY_MS`)을 2ms로 두었는데, 이 스텝 주파수가 28BYJ-48이 안정적으로 따라올 수 있는 속도보다 빨랐음
- **해결**: `STEP_FAST_DELAY_MS`를 **3ms**로 늘려 스텝 주파수를 낮춤 → 탈조 없이 목표 위치에 도달

## 하드웨어

| 부품 | 인터페이스 | 핀 |
|---|---|---|
| 초침 스텝 모터 (28BYJ-48) | GPIO 4선 | PA0, PA1, PA4, PB0 |
| 분침 스텝 모터 | GPIO 4선 | PC10, PC11, PC12, PD2 |
| 시침 스텝 모터 | GPIO 4선 | PC9, PC8, PC6, PC5 |
| DS3231 RTC, 16x2 LCD | I2C1 | PB8(SCL), PB9(SDA) |
| 모드 버튼 | GPIO 입력 | PC0 |

## 소프트웨어 구조

```
STM32_Analog_Clock_Project_Team6/Core/Src
├── ap/
│   ├── ap_main.c          # 모드 FSM, 바늘 목표 계산, 타이머 콜백
│   ├── TimeClock/         # RTC 기반 시계
│   ├── StopWatch/         # 스톱워치
│   └── Display/           # LCD 출력
└── driver/
    ├── stepmotor/         # 스텝 모터 (하프스텝, 목표 추종)
    ├── ds3231/            # I2C RTC
    ├── lcd/  button/  fnd/  led/
```

## 개발 환경

STM32CubeIDE, STM32 HAL (STM32F4xx), C, Git/GitHub (브랜치 + Pull Request 협업)
