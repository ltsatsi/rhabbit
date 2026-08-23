// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

class TimeService {
  String getMonth({required int month}) {
    // invalid input
    if (month > 12 || month <= 0) {
      return '';
    }

    // conditional switch
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'Feburary';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'Spetember';
      case 10:
        return 'Octopber';
      case 11:
        return 'Novemebr';
      case 12:
        return 'Decemeber';
    }
    return '';
  } // end method

  String getFormattedTime({
    required int remainingHours,
    required int remainingMinutes,
    required int remainingSeconds,
  }) {
    final hours = remainingHours.toString().padLeft(2, '0');
    final minutes = remainingMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remainingSeconds.remainder(60).toString().padLeft(2, '0');

    return '${hours == '00' ? '' : '$hours:'}$minutes:$seconds';
  } // end method
} // end class
