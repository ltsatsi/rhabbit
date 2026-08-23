// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

class HeatMapService {
  // clean raw data
  Map<DateTime, int> cleanDataset(Map<DateTime, int> data) {
    return {
      for (final entry in data.entries)
        DateTime(entry.key.year, entry.key.month, entry.key.day): entry.value,
    };
  } // end method
} // end class
