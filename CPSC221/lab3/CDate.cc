// ..................................................  
// CDate class definitions
// Adapted from Hagit Schechter, Jan 2007 for 2014W2 
// ..................................................

#include <iostream>
#include <string>
#include "CDate.h"

CDate::CDate(void){
	m_year = m_month = m_day = 0;
}

CDate::CDate(int year, int month, int day){
	setDate( year, month, day );        
}

CDate::CDate(int year, std::string month, int day){
  int months = CDate::monthStr2Num(month);
  setDate( year, months, day ); 
}

bool CDate::isValidDate(int year, int month, int day){
  if(year >= 0 && month >= 1 && month <= 12 && CDate::isValidDay(year, month, day)){
  return true;
  }
  else{
	return false;
	}
}

bool CDate::isValidDate(int year, std::string month, int day){
	int months = monthStr2Num(month);
	return isValidDate(year, months, day);
	
}

int CDate::monthStr2Num(std::string month){
  const char* const months[12] = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
  int i;
  for(i = 0; i < 12; i++){
  if(month.compare(months[i]) == 0){
    return i+1;
    }
} 
	return -1;
}

bool CDate::isValidDay(int year, int month, int day){
	if ((day < 1) || (day > 31)) return false;

	bool valid = false;
	switch (month) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			if(day <= 31 && day > 0)
			valid = true ;
			break;
			
		case 2:
			// Don't worry about this code too much.
			// It handles all the leap year rules for February.
			if ((year % 4) != 0) {
				valid = (day <=28);
			} else if ((year % 400) == 0) {
				valid = (day <= 29);
			} else if ((year % 100) == 0) {
				valid = (day <= 28);
			} else {
				valid = (day <= 29);
			}
			break;
		case 4:
		case 6:
		case 9:
		case 11:
			if(day <= 30 && day > 0)
        valid = true;
			break;
		default:
			break;
			 
	}

	return valid;
}

void CDate::setDate(int year, int month, int day){
	if(isValidDate(year, month, day)){    
		m_year = year;
		m_month = month;
		m_day = day;
	}
	else {
		m_year = m_month = m_day = 0;
	}
	return;
}


void CDate::setDate(int year, std::string month, int day){
	int months = CDate::monthStr2Num(month);
	CDate::setDate(year, months, day);
}

void CDate::print(void){
	std::cout << m_year << "/" << m_month << "/" << m_day << std::endl;
}

int CDate::getDate(void){
	return (m_year * 10000) + (m_month * 100) + m_day;
}

