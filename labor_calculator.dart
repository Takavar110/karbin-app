class LaborCalculator {
  // ۱. محاسبه حق سنوات (ماده ۲۴ قانون کار)
  static double calculateSanavat({
    required double lastDailyWage,
    required int totalWorkingDays,
  }) {
    if (totalWorkingDays <= 0 || lastDailyWage <= 0) return 0;
    double monthlyWage = lastDailyWage * 30;
    return (totalWorkingDays / 365.0) * monthlyWage;
  }

  // ۲. محاسبه بازخرید مانده مرخصی (ماده ۶۴ و ۷۱ قانون کار)
  static double calculateLeaveBuyout({
    required double lastDailyWage,
    required double remainingDays,
  }) {
    if (remainingDays <= 0 || lastDailyWage <= 0) return 0;
    return remainingDays * lastDailyWage;
  }

  // ۳. ارزیابی و محاسبه مقرری بیمه بیکاری (مواد ۶ و ۷ قانون بیمه بیکاری)
  static Map<String, dynamic> evaluateUnemployment({
    required bool isInvoluntary,
    required int insuranceMonthsInLastJob,
    required int daysSinceDismissal,
    required double averageLast90DaysDailyWage,
    required int dependentsCount,
    required double dailyMinWage,
  }) {
    if (!isInvoluntary) {
      return {
        'eligible': false,
        'reason': 'طبق ماده ۲ قانون بیمه بیکاری، قطع همکاری باید غیرارادی باشد.'
      };
    }

    if (insuranceMonthsInLastJob < 6) {
      return {
        'eligible': false,
        'reason': 'حداقل ۶ ماه سابقه بیمه در آخرین کارگاه پیش از بیکاری الزامی است.'
      };
    }

    if (daysSinceDismissal > 30) {
      return {
        'eligible': false,
        'reason': 'مهلت قانونی مراجعه به اداره کار حداکثر ۳۰ روز از تاریخ بیکاری است.'
      };
    }

    // ۵۵ درصد متوسط مزد ۹۰ روز آخر
    double dailyBenefit = averageLast90DaysDailyWage * 0.55;

    // ۱۰ درصد حداقل مزد به ازای هر تحت تکفل تا ۴ نفر
    int validDependents = dependentsCount.clamp(0, 4);
    dailyBenefit += validDependents * (dailyMinWage * 0.10);

    // رعایت کف (حداقل دستمزد) و سقف (۸۰ درصد مزد بیمه‌شده)
    if (dailyBenefit < dailyMinWage) {
      dailyBenefit = dailyMinWage;
    }
    double maxCap = averageLast90DaysDailyWage * 0.80;
    if (dailyBenefit > maxCap) {
      dailyBenefit = maxCap;
    }

    return {
      'eligible': true,
      'monthlyBenefit': dailyBenefit * 30,
      'dailyBenefit': dailyBenefit,
      'dependentsCount': validDependents,
    };
  }
}
