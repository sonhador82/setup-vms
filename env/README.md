### Требования к хосту виртуализации (вместо vagranta)
Или "железный" хост с ubuntu 16.04, с ЦПУ с поддержкой ускорения виртуализации

Или виртуалка с ubuntu 16.04 на хосте с ^^^ + опцией nested модуля kvm-intel|amd (для т.н. nested виртуализацией) + настройка проца host-passthrough 
 
### Подготовка окружения, создание ВМ-ок, подготовка нетворга и т.д.
на хосте или вм-ке с nested, выполнить:
```bash
mkdir -p /test_case && apt-get update && apt-get install git
cd /test_case && git clone git@github.com:sonhador82/setup-vms.git
cd /test_case/setup-vms/env

# необходимые пакетики и ансибля, python2.7
./setup_env.sh

# исошки с бутстрапом вм-ок
ansible-playbook ./setup_isos.yml

# создание комплекта вм-ок
./setup_vms.sh 

# проверка сетки с вм-ками
./check_net_connect.sh
```
