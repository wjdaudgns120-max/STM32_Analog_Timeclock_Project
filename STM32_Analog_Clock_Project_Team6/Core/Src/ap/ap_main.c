/*
 * ap_main.c
 *
 *  Created on: 2026. 10. 16.
 *      Author: rhoblack
 */

#include "ap_main.h"
#include "StopWatch/StopWatch.h"
#include "TimeClock/TimeClock.h"
#include "Display/Display.h"
#include "../driver/fnd/fnd.h"
#include "../driver/button/button.h"
#include "../driver/led/led.h"
#include "../driver/stepmotor/stepmotor.h"



enum {TIME_CLOCK_MODE, STOP_WATCH_MODE};

extern TIM_HandleTypeDef htim3;
extern TIM_HandleTypeDef htim4;

button_t btnMode;

stepMotor_pin_t stepMotorPinSec = { .port = { GPIOA, GPIOA, GPIOA, GPIOB },
		.pin = { GPIO_PIN_0, GPIO_PIN_1, GPIO_PIN_4, GPIO_PIN_0 } };

stepMotor_t motor_sec = { .pin = &stepMotorPinSec, .stepCounter = 0, .position = 0 };

int modeState = TIME_CLOCK_MODE;


void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
	if (htim->Instance == TIM3) {
		//fnd_show_number();
		Disp_ISR();
		// 1ms마다 호출. super loop는 LCD 출력 때문에 느려서 스텝은 타이머 인터럽트에서 돌린다.
		StepMotor_task(&motor_sec);
	}
	else if (htim->Instance == TIM4) {
		TimeClock_ISR();
		StopWatch_ISR();
	}
}

// 현재 모드의 초(+1/100초) 값에 맞춰 초침 목표 위치를 갱신한다.
// msec까지 반영해서 목표가 연속으로 움직이므로 초침이 60초에 한 바퀴 부드럽게 돈다.
void ap_secHandTask(void)
{
	uint8_t sec, msec;

	if (modeState == TIME_CLOCK_MODE) {
		TimeClock_t *t = TimeClock_getTimeData();
		sec = t->sec;
		msec = t->msec;
	}
	else {
		stopWatch_t *t = StopWatch_getTimeData();
		sec = t->sec;
		msec = t->msec;
	}

	uint32_t centiSec = (uint32_t)sec * 100 + msec;	// 0 ~ 5999
	StepMotor_setTarget(&motor_sec, centiSec * STEPS_PER_REV / 6000);
}

void ap_init(void)
{
	StopWatch_init();
	TimeClock_init();
	Disp_init();

	StepMotor_init(&motor_sec, &stepMotorPinSec);

	button_init(&btnMode, GPIOC, GPIO_PIN_0);

	HAL_TIM_Base_Start_IT(&htim3);
	HAL_TIM_Base_Start_IT(&htim4);
}

void ap_timeClockMode(void)
{
	if (button_getState(&btnMode) == ACT_RELEASE) {
		modeState = STOP_WATCH_MODE;
	}
	TimeClock_task();

	TimeClock_t *pTimeClockTime = TimeClock_getTimeData();
	Disp_setTimeClockTime((timeClockTime_t *)pTimeClockTime);

	TimeDate_t *pTimeDate = TimeClock_getDateData();
	Disp_setTimeClockDate((timeClockDate_t *)pTimeDate);

	Disp_setMode(modeState);
}

void ap_stopWatchMode(void)
{
	if (button_getState(&btnMode) == ACT_RELEASE) {
		modeState = TIME_CLOCK_MODE;
	}
	StopWatch_task();

	stopWatch_t *pStopWatchTime = StopWatch_getTimeData();
	Disp_setStopWatchTime((stopWatchTime_t *)pStopWatchTime);

	stopWatch_state_t stopWatchState = StopWatch_getState();
	Disp_setStopWatchState(stopWatchState);

	Disp_setMode(modeState);
//	TimeClock_t *pTimeClockTime = TimeClock_getTimeData();
//	Disp_setTimeClockTime((timeClockTime_t *)pTimeClockTime);
}

int ap_main(void)
{
	ap_init();

	while(1) // super loop
	{
		TimeClock_task();
		switch (modeState)
		{
		case TIME_CLOCK_MODE:
			ap_timeClockMode();
			break;
		case STOP_WATCH_MODE:
			ap_stopWatchMode();
			break;
		default:
			break;
		}
		ap_secHandTask();
	}
	return 0;
}
