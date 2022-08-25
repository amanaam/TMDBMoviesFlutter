enum Environment {
  LOCAL,
  DEV,
  PROD,
}

enum Conf {
  baseUrl,
  apiKey,
  language,
}

class AppConfig {
  static late Environment _env;

  static void setEnvironment(Environment env) {
    _env = env;
  }

  static Environment get env {
    return _env;
  }

  static dynamic get(Conf c) {
    return _conf[_env]![c];
  }

  static const Map<Environment, Map<Conf, dynamic>> _conf = {
    Environment.LOCAL: {
      Conf.baseUrl: 'https://api.themoviedb.org/3/',
      Conf.apiKey: '840b96f3d20796ffdc21e782f84d3262',
      Conf.language: 'en-US',
    },
    Environment.DEV: {
      Conf.baseUrl: 'https://api.themoviedb.org/3/',
      Conf.apiKey: '840b96f3d20796ffdc21e782f84d3262',
      Conf.language: 'en-US',
    },
    Environment.PROD: {
      Conf.baseUrl: 'https://api.themoviedb.org/3/',
      Conf.apiKey: '840b96f3d20796ffdc21e782f84d3262',
      Conf.language: 'en-US',
    },
  };
}

extension ConfGet on Conf {
  dynamic get get => AppConfig.get(this);
}
