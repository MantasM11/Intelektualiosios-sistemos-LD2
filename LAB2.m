clc
clear all
close all

%% Tinklo inicializavimas

% Pirmas sluoksnis – 4 pasleptieji neuronai
w11_1 = rand(1);
w21_1 = rand(1);
w31_1 = rand(1);
w41_1 = rand(1);

b1_1 = rand(1);
b2_1 = rand(1);
b3_1 = rand(1);
b4_1 = rand(1);

% Antras sluoksnis – 1 isejimo neuronas
w11_2 = rand(1);
w21_2 = rand(1);
w31_2 = rand(1);
w41_2 = rand(1);

b1_2 = rand(1);

% Mokymosi zingsnis
eta = 0.1;

%% Tinklo mokymas

for iter = 1:80000
    for i = 1:20

        % Vienas mokymo taskas, be duomenu masyvu
        x = 0.1 + (i-1)/22;

        % Norimas atsakymas
        d = (1 + 0.6*sin(2*pi*x/0.7) + 0.3*sin(2*pi*x))/2;

        % Pirmo sluoksnio pasvertos sumos
        v1_1 = x*w11_1 + b1_1;
        v2_1 = x*w21_1 + b2_1;
        v3_1 = x*w31_1 + b3_1;
        v4_1 = x*w41_1 + b4_1;

        % Pirmo sluoksnio aktyvacijos funkcija
        y1_1 = tanh(v1_1);
        y2_1 = tanh(v2_1);
        y3_1 = tanh(v3_1);
        y4_1 = tanh(v4_1);

        % Antro sluoksnio pasverta suma
        v1_2 = y1_1*w11_2 + y2_1*w21_2 + y3_1*w31_2 + y4_1*w41_2 + b1_2;

        % Isejimo aktyvacijos funkcija – tiesine
        y1_2 = v1_2;
        y = y1_2;

        % Klaida
        e = d - y;

        %% Atgalinis sklidimas

        % Isejimo sluoksnio klaidos signalas
        delta1_2 = e;

        % Pasleptojo sluoksnio klaidos signalai
        % tanh isvestine: 1 - tanh(v)^2
        delta1_1 = (1-tanh(v1_1)^2)*delta1_2*w11_2;
        delta2_1 = (1-tanh(v2_1)^2)*delta1_2*w21_2;
        delta3_1 = (1-tanh(v3_1)^2)*delta1_2*w31_2;
        delta4_1 = (1-tanh(v4_1)^2)*delta1_2*w41_2;

        % Visos deltos apskaiciuotos pries keiciant svorius

        %% Svoriu ir poslinkiu atnaujinimas

        % Isejimo sluoksnis
        w11_2 = w11_2 + eta*delta1_2*y1_1;
        w21_2 = w21_2 + eta*delta1_2*y2_1;
        w31_2 = w31_2 + eta*delta1_2*y3_1;
        w41_2 = w41_2 + eta*delta1_2*y4_1;

        b1_2 = b1_2 + eta*delta1_2;

        % Pasleptojo sluoksnio svoriai
        w11_1 = w11_1 + eta*delta1_1*x;
        w21_1 = w21_1 + eta*delta2_1*x;
        w31_1 = w31_1 + eta*delta3_1*x;
        w41_1 = w41_1 + eta*delta4_1*x;

        % Pasleptojo sluoksnio poslinkiai
        b1_1 = b1_1 + eta*delta1_1;
        b2_1 = b2_1 + eta*delta2_1;
        b3_1 = b3_1 + eta*delta3_1;
        b4_1 = b4_1 + eta*delta4_1;

    end
end

%% Apmokyto tinklo patikrinimas ir grafikas

figure
hold on
grid on

% Grafiko taskai pridedami po viena
tikroji = animatedline('Color','b','LineStyle','none','Marker','o','MarkerFaceColor','b','MarkerSize',6);
tinklo = animatedline('Color','r','LineWidth',1.5);

klaidu_suma = 0;

for i = 1:20

    x_new = 0.1 + (i-1)/22;

    % Norimas atsakymas
    d = (1 + 0.6*sin(2*pi*x_new/0.7) + 0.3*sin(2*pi*x_new))/2;

    % Pirmo sluoksnio pasvertos sumos
    v1_1 = x_new*w11_1 + b1_1;
    v2_1 = x_new*w21_1 + b2_1;
    v3_1 = x_new*w31_1 + b3_1;
    v4_1 = x_new*w41_1 + b4_1;

    % Pirmo sluoksnio aktyvacijos funkcija
    y1_1 = tanh(v1_1);
    y2_1 = tanh(v2_1);
    y3_1 = tanh(v3_1);
    y4_1 = tanh(v4_1);

    % Antro sluoksnio pasverta suma
    v1_2 = y1_1*w11_2 + y2_1*w21_2 + y3_1*w31_2 + y4_1*w41_2 + b1_2;

    % Tiesine isejimo aktyvacijos funkcija
    y1_2 = v1_2;
    y = y1_2;

    % Klaida su galutiniais svoriais
    e = d - y;
    klaidu_suma = klaidu_suma + e^2;

    % Tasku pridejimas i grafika
    addpoints(tikroji, x_new, d);
    addpoints(tinklo, x_new, y);

    fprintf('x = %.4f, d = %.4f, y = %.4f, klaida = %.4f\n', ...
            x_new, d, y, e);

end

% Vidutine kvadratine klaida mokymo taskuose
% Tai patikrinimas tais paciais taskais, kurie naudoti mokymui
MSE = klaidu_suma/20;
fprintf('Mokymo tasku MSE: %.8f\n', MSE);

xlabel('x');
ylabel('Funkcijos reiksme');
title('Funkcijos aproksimavimas su 4 pasleptaisiais neuronais');
legend('Norima funkcija', 'Tinklo atsakymas', 'Location', 'best');

drawnow
hold off