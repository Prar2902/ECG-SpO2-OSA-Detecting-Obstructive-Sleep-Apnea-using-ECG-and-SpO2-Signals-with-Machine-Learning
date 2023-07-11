clc
clear all;

fs=100;
l=load("Sleep.csv");
x=l(:,1)
Desired_Signal = x/2;
Desired_Signal=Desired_Signal';
figure(1)
subplot(2,1,1)
plot(Desired_Signal,'color','b',LineWidth=2)
xlabel("Samples");
ylabel("Amplitude");
title(['ECG']);

Q = size(Desired_Signal);
% Adding noise to the datasets
figure(1);
subplot(2,1,2);
Signal_with_noise = awgn(Desired_Signal,25);
plot(Signal_with_noise,'color','g',LineWidth=2);
title("Noise added with ECG");

% RLS filter
ita=10^4;
n = numel(Desired_Signal)
I = ones(1,n);
R = ita*I;
w = zeros(1,n);
for i = 1:n
 z(I) = w(i)'*Desired_Signal(i);
 Err(I) = Signal_with_noise(i)-z(i);
 a(I) = R(i)'*Desired_Signal(i);
 q = Desired_Signal(i)'*a(i);
 v = 1/(1+q);
 zz(I) = v*a(i);
 w(i+1) = w(i)+Err(i)*zz(i);
 R(i+1) = R(i)-zz(i)*a(i);
end
for i=1:n
 B(i) = sum(w(i)'*Desired_Signal(i));
end
figure(2)
plot(B,'color','m',LineWidth=2)
title("RLS Filter");
B = abs(B).^2;
[qrspeaks,locs] = findpeaks(B,'MinPeakHeight',0.35,...
'MinPeakDistance',0.150);
figure (3)
plot(B)
hold on
plot(locs,qrspeaks,'ro')
xlabel('Samples')
title('R Peaks Localized by Wavelet Transform')

%SPO2 data
p=l(:,5);
figure(4)
plot(p,'color','b',LineWidth=2)
xlabel("time");
ylabel("Amplitude");
title('SPO2');

% O2 level features
min_SPO2=min(p);
max_SPO2=max(p)
mean_SPO2=mean(p);

%Average RR interval
RR1 = diff(locs);
RR=mean(RR1);
RR_Interval=RR/100;

%%desaturation detection
des=0;
for i=1:6000
 if p(i)<94
 des=des+1;
 end

end
Desaturation=des/(60);
Variance_SPO2=var(p)

%ECG features
VarianceRR=var(RR1)/100
14
%Heart rate calculator
heart_rate1=size(locs);
heart_rate=heart_rate1(2)

%feature
%Sleep Apnea detection
count =0;
if(min_SPO2<95 && min_SPO2>90)
 count=count+1;
end
if(RR_Interval>1.2 && RR_Interval<0.6 )
 count=count+1;
end
if(Desaturation>5)
 count=count+1
end

%SPO2 summary
sumar=table(min_SPO2,max_SPO2,Variance_SPO2,mean_SPO2,Desaturati
on)
sumar

%ECG summary
sumar1=table(RR_Interval,VarianceRR,heart_rate)
if(count>=2)
 fprintf("The person is sufferening from sleep apnea")
else
 fprintf("The person is not sufferening from sleep apnea")
end
