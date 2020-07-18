
function f = embedding(cover_image, secure_message)
	% As per paper set initial values of x, y, z between [0,1]
	x=0.3;
	y=0.6;
	z=0.9;
	% As per paper set control parameter values alpha, beta, gamma between [0.5,4]
	alpha = 1;
	beta = 2;
	gamma = 3;

	CI = imread(cover_image);
	[i,j,k] = size(CI);
	SM = rgb2gray(imread(secure_message));
	[m,n] = size(SM);
    SM=SM(:)';
	LS = liftwave('haar','Int2Int');
    [CA,CH,CV,CD] = lwt2(double(CI), LS);
    TI = [CA,CH;CV,CD];

	flag = ones(i,j,k);
	for D=1:m*n
 
		x = mod(((alpha+x*(1-x))/(y*(1-y))),1);
		y = mod(((beta+y*(1-y))/(z*(1-z))),1);
		z = mod(((gamma+z*(1-z))/(x*(1-x))),1);
		xx = mod(round(x*10.^14),i)+1;
		yy = mod(round(y*10.^14),j)+1;
		zz = mod(round(z*10.^14),k)+1;

		if flag(xx,yy,zz)==1            
			bitset(uint8(TI(xx,yy,zz)),1:8, bitget(SM(1,D),1:8));
			flag(xx,yy,zz)=0;
		end
    end
    
    CA = TI(1:256,1:256,:);
	CH = TI(257:512,1:256,:);
	CV = TI(1:256,257:512,:);
	CD = TI(257:512,257:512,:);
    S = ilwt2(CA,CH,CV,CD,LS);
	imwrite(uint8(S), 'stego.png')


