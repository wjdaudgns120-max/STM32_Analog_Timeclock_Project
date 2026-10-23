/*
 * TimeClock.c
 *
 *  Created on: 2026. 10. 19.
 *      Author: rhoblack
 */
#include "TimeClock.h"
#include "../../driver/fnd/fnd.h"
#include "../../driver/ds3231/ds3231.h"
#include <stdio.h>
#include <string.h>

extern I2C_HandleTypeDef hi2c1;

static TimeClock_t 	timeClockData; // 중심 데이터
static TimeDate_t	timeDateData;

ds3231_datetime_t rtc_datetime = {
		.date = {.year = 26, .month = 10, .date = 22, .day = 5},
		.time = {.hour = 11, .min	= 44, .sec 	= 30}
};
ds3231_time_t rtc_time;
ds3231_date_t rtc_date;

void TimeClock_init(void)
{
	ds3231_init(&hi2c1);
	ds3231_getDateTime(&rtc_datetime);
	ds3231_getTime(&rtc_time);
	ds3231_getDate(&rtc_date);

	timeClockData.hour = rtc_datetime.time.hour;
	timeClockData.min = rtc_datetime.time.min;
	timeClockData.sec = rtc_datetime.time.sec;
	timeClockData.msec = 0;
}

TimeClock_t *TimeClock_getTimeData(void)
{
	timeClockData.hour = rtc_time.hour;
	timeClockData.min = rtc_time.min;
	timeClockData.sec = rtc_time.sec;

	return &timeClockData;
}

TimeDate_t *TimeClock_getDateData(void)
{
	static TimeDate_t prevDate = {0};

	if (!memcmp(&prevDate, &timeDateData, sizeof(TimeDate_t))){
	timeDateData.year = rtc_date.year;
	timeDateData.month = rtc_date.month;
	timeDateData.date = rtc_date.date;
	timeDateData.day = rtc_date.day;
	}
	memcpy(&prevDate, &timeDateData, sizeof(TimeDate_t));


	return &timeDateData;
}

static void TimeClock_incMSec(void)
{
	if (timeClockData.msec < 99) {
		timeClockData.msec++;
		return;
	}
	timeClockData.msec = 0;
	if (timeClockData.sec < 59) {
		timeClockData.sec++;
		return;
	}
	timeClockData.sec = 0;
	if (timeClockData.min < 59) {
		timeClockData.min++;
		return;
	}
	timeClockData.min = 0;
	if (timeClockData.hour < 23) {
		timeClockData.hour++;
		return;
	}
	timeClockData.hour = 0;
}

void TimeClock_ISR(void)
{
	TimeClock_incMSec();
//	TimeClock_getTimeData();
}

void TimeClock_task(void)
{
	static uint8_t prevSec = 0;
	static uint8_t prevHour = 0;

	if(timeClockData.sec == prevSec) {
		return;
	}
	prevSec = timeClockData.sec;
	ds3231_getTime(&rtc_time);

	if(timeClockData.hour == prevHour) {
		return;
	}
	prevHour = timeClockData.hour;
	ds3231_getDate(&rtc_date);
	//TimeClock_dispTime();
}









