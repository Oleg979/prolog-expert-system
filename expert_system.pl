:- encoding(utf8).
:- dynamic yes/1, no/1. 

% Модуль интерфейса пользователя
main_module :-
      set_prolog_flag(encoding, utf8),
      load_objects,
      load_features, 
      writeln('Добро пожаловать в экспертную систему по определению фреймворков!'),
      writeln('Я помогу вам подобрать подходящий фреймворк для разработки.'),
      menu_module,
      main_module.

menu_module :-
      writeln('Выберите один из пунктов меню:'),
      writeln('1. Запустить экспертную систему'),
      writeln('2. Добавить новый признак'),
      writeln('3. Добавить новый объект'),
      read_line_to_string(user_input, Response), nl,
      (((Response = "1"), expert_system_module) ;
      ((Response = "2"), add_feature)) ;
      ((Response = "3"), add_object) ;
      menu_module.

expert_system_module :-  
     answer(Framework), !,
     write('Вам подходит фреймворк '), 
     write(Framework), 
     nl, nl, nl,
     undo.

% Модуль подгрузки базы знаний
load_objects :- 
      writeln('Загружаю признаки...'), 
      consult('C:/SSTU Projects/prolog-scripts/objects.pl').
load_features :- 
      writeln('Загружаю объекты...'), 
      consult('C:/SSTU Projects/prolog-scripts/features.pl').

% Модуль добавления нового признака
add_feature :-
      writeln('Введите название нового признака:'),
      read_line_to_string(user_input, Response), nl,
      open('C:/SSTU Projects/prolog-scripts/features.pl', append, File),
      nl(File),
      write(File,"feature('"),
      write(File, Response),
      write(File, "')."),
      close(File),
      writeln('Признак успешно добавлен!'), nl, nl.

% Модуль добавления нового объекта
add_object :-
      writeln('Введите название нового фреймворка:'),
      read_line_to_string(user_input, Name), nl,
      open('C:/SSTU Projects/prolog-scripts/objects.pl', append, File),
      nl(File),
      write(File, "answer('"),
      write(File, Name),
      write(File, "') :- "),
      not(write_features(Name, File)),
      write(File, "true."),
      close(File),
      writeln('Фреймворк успешно добавлен!'), nl, nl.

write_features(Name, File) :-
      feature(X),
      write('Обладает ли '),
      write(Name),
      write(' следующей характеристикой: '),
      write(X), writeln('? '), 
      read_line_to_string(user_input, Response), nl,
      Response = "да", 
      write(File, "verify('"),
      write(File, X),
      write(File, "'), "),
      fail.

% Модуль вывода
ask(Question) :- 
      writeln('Обладает ли фреймворк следующей характеристикой: '), 
      write(Question), writeln('? '), 
      read_line_to_string(user_input, Response), nl,
      (Response = "да", assertz(yes(Question))) ; 
      (assertz(no(Question)), fail). 

verify(S) :- feature(S), (yes(S) -> true ; (no(S) -> fail ; ask(S))). 

undo :- retract(yes(_)), fail. 
undo :- retract(no(_)), fail. 
undo. 