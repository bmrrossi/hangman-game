#!/bin/bash
#
# hangman.sh 	: Hangman Game
# site				: http://www.terminalroot.com.br/
# author			: Marcos da B. M. Oliveira <contato@terminalroot.com.br>
# license     : MIT License (view file LICENSE)

shopt -s extglob

ctrl_c(){
	echo
	setterm -cursor on
	exit $?
}

trap ctrl_c SIGINT SIGTERM

if [[ "$(echo $LANG | cut -c 1-2)" == "pt" ]]; then
	export _lang=("uso" "parâmetro" "Opções" "Pressione qualquer tecla para descobrir a palavra secreta do jogo." "Exibe a versão" "Exibe essa mensagem" "Se você quiser adicionar palavras ao arquivo .palavras.txt, use palavras de 1 a 10 caracteres e não use palavras com acentos e caracteres que não letras ou números." "Palavras que contém números serão exibidos automaticamente" "versão" "Opção inválida." "Redimensione a janela do terminal para o tamanho máximo." "DIGITE UMA LETRA" "existe" "Para Sair tecle" "JOGO DA FORCA" "A PALAVRA ERA" "Parabéns!!!")
else
  export _lang=("usage" "flags" "Options" "Press any letter to try to find out the secret word of the game." "Show version" "Show this is message" "If you want to add words to the .palavras.txt file, use words from 1 to 10 characters and do not use words with accents and any characters other than letters or numbers." "Strings that have numbers will be displayed automatically." "version" "Invalid option." "Resize the terminal window to the maximum size." "ENTER A LETTER" "exists" "To Exit key" "HANGMAN GAME" "THE WORD WAS" "You Win !!!")
fi

usage() {
  cat <<EOF

${_lang[0]}: ${0##*/} [${_lang[1]}]

  ${_lang[2]}:
  
    ${_lang[3]}

    --version,-v   ${_lang[4]}
    --help,-h      ${_lang[5]}
    
  * ${_lang[6]}
  * ${_lang[7]}
    
EOF
}

	oldversion='2015-08-12'
  version="${0##*/} ${_lang[8]} 2018-09-07"

	if [[ $1 = @(-h|--help) ]]; then
		usage
		exit $(( $# ? 0 : 1 ))
	fi

	while [[ "$1" ]]; do
		      case "$1" in
		          "--help"|"-h") usage ;;
		          "--version"|"-v") printf "%s\n" "$version" ;;
		          *) echo '${_lang[9]}' && usage && exit 1 ;;
		      esac
		      shift
	done

	# Only start the game if the terminal window is at maximum size
	export _AVISO="${_lang[10]}"

	# minimum sizes for the terminal
	export _LINES=30
	export _COLS=130

	export _TITULO=" ${_lang[11]} "; # variavel de interação com o jogador
	export _URL="https://raw.githubusercontent.com/terroo/hangman-game/master/.palavras.txt"
	export _WORDS=".palavras.txt"

	# get the file if it is not in the game directory
	[ ! -e $_WORDS ] && wget $_URL -O $_WORDS 2>/dev/null;

	# if there is no _PALAVRA variable it creates it
	if [ -z "$_RAND" ]; then

		# count the words in the _WORDS file
		_ARRAY_PALAVRAS=$(cat $_WORDS | wc -l);
	
		# takes the number randomly, we add another 1, since the RANDOM index starts from zero
		_INDICE=$((($RANDOM%$_ARRAY_PALAVRAS)+1))
	
		# create _RAND not to join that block again
		export _PALAVRA=$(sed -n "$_INDICE p" $_WORDS | tr [A-Z] [a-z]) 
		_RAND="${_lang[12]}";
	fi

	# this variable displays the underlines instead of the letters, hiding the word
	export _LINHA=$(echo $_PALAVRA | sed 's/[a-z]/_/g');

	# variables to display the MENU and inform the phase of the game
	export _RESET="${_lang[13]}: [Ctrl + E|A]";
	export _EXIT="";
	export _FASE=""

	# Variables for creating game messages
	export _CREDITOS=$(printf \\$(printf "%03o" "67"))$(printf \\$(printf "%03o" "114"))$(printf \\$(printf "%03o" "105"))$(printf \\$(printf "%03o" "97"))$(printf \\$(printf "%03o" "100"))$(printf \\$(printf "%03o" "111"))$(printf \\$(printf "%03o" "32"))$(printf \\$(printf "%03o" "112"))$(printf \\$(printf "%03o" "111"))$(printf \\$(printf "%03o" "114"))$(printf \\$(printf "%03o" "32"))$(printf \\$(printf "%03o" "77"))$(printf \\$(printf "%03o" "97"))$(printf \\$(printf "%03o" "114"))$(printf \\$(printf "%03o" "99"))$(printf \\$(printf "%03o" "111"))$(printf \\$(printf "%03o" "115"))$(printf \\$(printf "%03o" "32"))$(printf \\$(printf "%03o" "100"))$(printf \\$(printf "%03o" "97"))$(printf \\$(printf "%03o" "32"))$(printf \\$(printf "%03o" "66"))$(printf \\$(printf "%03o" "46"))$(printf \\$(printf "%03o" "77"))$(printf \\$(printf "%03o" "46"))$(printf \\$(printf "%03o" "32"))$(printf \\$(printf "%03o" "79"))$(printf \\$(printf "%03o" "108"))$(printf \\$(printf "%03o" "105"))$(printf \\$(printf "%03o" "118"))$(printf \\$(printf "%03o" "101"))$(printf \\$(printf "%03o" "105"))$(printf \\$(printf "%03o" "114"))$(printf \\$(printf "%03o" "97"));
	export _HTTP=$(printf \\$(printf "%03o" "119"))$(printf \\$(printf "%03o" "119"))$(printf \\$(printf "%03o" "119"))$(printf \\$(printf "%03o" "46"))$(printf \\$(printf "%03o" "116"))$(printf \\$(printf "%03o" "101"))$(printf \\$(printf "%03o" "114"))$(printf \\$(printf "%03o" "109"))$(printf \\$(printf "%03o" "105"))$(printf \\$(printf "%03o" "110"))$(printf \\$(printf "%03o" "97"))$(printf \\$(printf "%03o" "108"))$(printf \\$(printf "%03o" "114"))$(printf \\$(printf "%03o" "111"))$(printf \\$(printf "%03o" "111"))$(printf \\$(printf "%03o" "116"))$(printf \\$(printf "%03o" "46"))$(printf \\$(printf "%03o" "99"))$(printf \\$(printf "%03o" "111"))$(printf \\$(printf "%03o" "109"))$(printf \\$(printf "%03o" "46"))$(printf \\$(printf "%03o" "98"))$(printf \\$(printf "%03o" "114"))
	export _CONGRA="${_lang[16]}"
	export _END=$(printf \\$(printf "%03o" "71"))$(printf \\$(printf "%03o" "65"))$(printf \\$(printf "%03o" "77"))$(printf \\$(printf "%03o" "69"))$(printf \\$(printf "%03o" "32"))$(printf \\$(printf "%03o" "79"))$(printf \\$(printf "%03o" "86"))$(printf \\$(printf "%03o" "69"))$(printf \\$(printf "%03o" "82"))



	# Array to create the game layout
	export JOGO_DA_FORCA=("               ████████████████████" "               █                  █" "               █                  █" "               █                  █" "               █             ██████████" "               █            ██░░O░|░O░██" "               █            ██░░░---░░██" "               █             ██████████" "               █                 ▌▌▌" "               █          ████████████████" "               █                 ▌▌▌" "               █                 ▌▌▌" "               █                █   █" "               █               █     █" "               █" "               █" "      ████████████████████"

	"               ████████████████████" "               █                  █" "               █                  █" "               █                  █" "               █" "               █" "               █" "               █" "               █" "               █" "               █" "               █" "               █" "               █" "               █" "               █" "      ████████████████████" "               █        \033[31;1m══════════▌═══════════> $_END\033[34;1m" "▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌" "▌▌▌                              █                           ▌▌▌" "▌▌▌                             █ █                          ▌▌▌" "▌▌▌  ██     ██  ██████  ██████ ██████                        ▌▌▌" "▌▌▌   ██   ██   ██  ██  █      █          $_CONGRA        ▌▌▌" "▌▌▌    ██ ██    ██  ██  █      ███                           ▌▌▌" "▌▌▌      █      ██████  ██████ ██████                        ▌▌▌" "▌▌▌                                                          ▌▌▌" "▌▌▌     ████    ████████ ████   ██ ██  ██  ██████  ██  ██ !! ▌▌▌" "▌▌▌    ██       ██    ██ ██ ██  ██ ██  ██  ██  ██  ██  ██ !! ▌▌▌" "▌▌▌   ██   ███  ████████ ██  █████ ██████  ██  ██  ██  ██ !! ▌▌▌" "▌▌▌    ██████   ██    ██ ██   ██   ██  ██  ██████  ██████ !! ▌▌▌" "▌▌▌                                                          ▌▌▌" "▌▌▌    $_CREDITOS                    ▌▌▌" "▌▌▌          $_HTTP                         ▌▌▌" "▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌");

	# create the gallows with certain elements of the declared Array
	export _FORCA="${JOGO_DA_FORCA[17]}\n${JOGO_DA_FORCA[18]}\n${JOGO_DA_FORCA[19]}\n${JOGO_DA_FORCA[20]}\n${JOGO_DA_FORCA[21]}\n${JOGO_DA_FORCA[22]}\n${JOGO_DA_FORCA[23]}\n${JOGO_DA_FORCA[24]}\n${JOGO_DA_FORCA[25]}\n${JOGO_DA_FORCA[26]}\n${JOGO_DA_FORCA[27]}\n${JOGO_DA_FORCA[28]}\n${JOGO_DA_FORCA[29]}\n${JOGO_DA_FORCA[30]}\n${JOGO_DA_FORCA[31]}\n${JOGO_DA_FORCA[32]}\n${JOGO_DA_FORCA[33]}";

	# creates the puppet's head with certain elements of the declared Array
	export _CABECA="${JOGO_DA_FORCA[0]}\n${JOGO_DA_FORCA[1]}\n${JOGO_DA_FORCA[2]}\n${JOGO_DA_FORCA[3]}\n${JOGO_DA_FORCA[4]}\n${JOGO_DA_FORCA[5]}\n${JOGO_DA_FORCA[6]}\n${JOGO_DA_FORCA[7]}\n${JOGO_DA_FORCA[25]}\n${JOGO_DA_FORCA[26]}\n${JOGO_DA_FORCA[27]}\n${JOGO_DA_FORCA[28]}\n${JOGO_DA_FORCA[29]}\n${JOGO_DA_FORCA[30]}\n${JOGO_DA_FORCA[31]}\n${JOGO_DA_FORCA[32]}\n${JOGO_DA_FORCA[33]}";

	# creates the doll's neck with certain elements of the declared Array
	export _PESCOCO="${JOGO_DA_FORCA[0]}\n${JOGO_DA_FORCA[1]}\n${JOGO_DA_FORCA[2]}\n${JOGO_DA_FORCA[3]}\n${JOGO_DA_FORCA[4]}\n${JOGO_DA_FORCA[5]}\n${JOGO_DA_FORCA[6]}\n${JOGO_DA_FORCA[7]}\n${JOGO_DA_FORCA[8]}\n${JOGO_DA_FORCA[26]}\n${JOGO_DA_FORCA[27]}\n${JOGO_DA_FORCA[28]}\n${JOGO_DA_FORCA[29]}\n${JOGO_DA_FORCA[30]}\n${JOGO_DA_FORCA[31]}\n${JOGO_DA_FORCA[32]}\n${JOGO_DA_FORCA[33]}";

	# creates the puppet body with certain elements of the declared Array
	export _CORPO="${JOGO_DA_FORCA[0]}\n${JOGO_DA_FORCA[18]}\n${JOGO_DA_FORCA[19]}\n${JOGO_DA_FORCA[20]}\n${JOGO_DA_FORCA[4]}\n${JOGO_DA_FORCA[5]}\n${JOGO_DA_FORCA[6]}\n${JOGO_DA_FORCA[7]}\n${JOGO_DA_FORCA[8]}\n${JOGO_DA_FORCA[9]}\n${JOGO_DA_FORCA[10]}\n${JOGO_DA_FORCA[11]}\n${JOGO_DA_FORCA[29]}\n${JOGO_DA_FORCA[30]}\n${JOGO_DA_FORCA[31]}\n${JOGO_DA_FORCA[32]}\n${JOGO_DA_FORCA[33]}";

	# creates the puppet's legs with certain elements of the declared Array
	export _PERNA="${JOGO_DA_FORCA[0]}\n${JOGO_DA_FORCA[18]}\n${JOGO_DA_FORCA[19]}\n${JOGO_DA_FORCA[20]}\n${JOGO_DA_FORCA[4]}\n${JOGO_DA_FORCA[5]}\n${JOGO_DA_FORCA[6]}\n${JOGO_DA_FORCA[7]}\n${JOGO_DA_FORCA[8]}\n${JOGO_DA_FORCA[9]}\n${JOGO_DA_FORCA[10]}\n${JOGO_DA_FORCA[11]}\n${JOGO_DA_FORCA[12]}\n${JOGO_DA_FORCA[13]}\n${JOGO_DA_FORCA[31]}\n${JOGO_DA_FORCA[32]}\n${JOGO_DA_FORCA[33]}";

	# displays the hanging
	export _ENFORCA="${JOGO_DA_FORCA[0]}\n${JOGO_DA_FORCA[18]}\n${JOGO_DA_FORCA[19]}\n${JOGO_DA_FORCA[20]}\n${JOGO_DA_FORCA[4]}\n${JOGO_DA_FORCA[5]}\n${JOGO_DA_FORCA[6]}\n${JOGO_DA_FORCA[7]}\n${JOGO_DA_FORCA[34]}\n${JOGO_DA_FORCA[9]}\n${JOGO_DA_FORCA[10]}\n${JOGO_DA_FORCA[11]}\n${JOGO_DA_FORCA[12]}\n${JOGO_DA_FORCA[13]}\n${JOGO_DA_FORCA[31]}\n${JOGO_DA_FORCA[32]}\n${JOGO_DA_FORCA[33]}";

	# displays the final game screen
	export _VENCE="${JOGO_DA_FORCA[35]}\n${JOGO_DA_FORCA[36]}\n${JOGO_DA_FORCA[37]}\n${JOGO_DA_FORCA[38]}\n${JOGO_DA_FORCA[39]}\n${JOGO_DA_FORCA[40]}\n${JOGO_DA_FORCA[41]}\n${JOGO_DA_FORCA[42]}\n${JOGO_DA_FORCA[43]}\n${JOGO_DA_FORCA[44]}\n${JOGO_DA_FORCA[45]}\n${JOGO_DA_FORCA[46]}\n${JOGO_DA_FORCA[47]}\n${JOGO_DA_FORCA[48]}\n${JOGO_DA_FORCA[49]}\n${JOGO_DA_FORCA[50]}\n${JOGO_DA_FORCA[51]}"

	# Terminal size validation
	redimensiona_terminal(){

		# Take the size of the Terminal
		local _LINES_TERM=$(tput lines);
		local _COLS_TERM=$(tput cols);

		if [ $_LINES_TERM -lt $_LINES ] || [ $_COLS_TERM -lt $_COLS ]; then
			echo -e "\033[99;1m$_AVISO\033[m";
			exit 1;
		else	
			reset; # resetamos a tela para iniciar o jogo
			setterm -cursor off; # desligamos o cursor
		fi

	}

	# call the validation function
	redimensiona_terminal

	# this function displays the character that the player types, if this character exists in the word
	exibir_caracter_correto(){

	# The variable '_X' takes the character entered by the parameter $ 1; the position is empty, but below explain; and the space is $ _LINHA
	local _X=$1;
	local _POSICAO='';
	local _ESPACOS=$_LINHA;

	# this loop defines the variables: _LETRA (1 character of position N of _PALAVRA), if it is equal to _X concatenates the position in _POSICAO
	# The sequence starts from zero to the number of characters of _PALAVRA minus 1, since the count of #var starts from 0 and the string starts from 1
	for i in $(seq 0 $((${#_PALAVRA}-1)))
	do

	 # read 1 to 1 character of the _PALAVRA string, until you find the letter that is the same as that typed by the player
	 # If you find concatenation to _POSICAO (_POSICAO can be 134, it means that the letter entered is in positions 1, 3 and 4)
	 local _LETRA=${_PALAVRA:$i:1};
	 if [ "$_LETRA" == "$_X" ];then
	 	_POSICAO="$_POSICAO$i"
	 fi
	 
	done
	 
	# Loop from zero to amount of _POSICAO also from zero to inform which character ($ char) will be changed by SED
	for i in $(seq 0 $((${#_POSICAO}-1)))
	do

		# takes the letter, #FIXME, when it is greater than 10, there is an error.
		char=${_POSICAO:$i:1}

		# as the amount was from zero, it should add 1 more, as the SED starts from the 1st exchange
		let "char=char + 1"

		# is used to display the new word formation with the letters found
		# That is, if you continue with the _ESPACOS variable, grep will continue to fetch from _PALAVRA, and it will generate an error
		# For this not to happen, the variable _NEW was created, if it exists it is done grep in _PALAVRA, but replaces in the new _ESPACOS
		if [[ $_NEW ]]; then
		_NEW=$(echo $_NEW | sed "s/./$_X/$char")
		else
		#troca the letter $ _X by in position $ char
		_ESPACOS=$(echo $_ESPACOS | sed "s/./$_X/$char")
		fi

	done

	# already explained above
	[[ $_NEW ]] && _NEW=$_NEW || _NEW=$_ESPACOS
	}


	# mother loop that will display the game
	while :
	do

		# positioned the title
		tput cup 0 20
		echo -e "\033[99;1m░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
		tput cup 1 20

		# show color
		echo -e "░░░░░░░░░░\033[34;1m${_lang[14]}\033[99;0m░░░░░░░░░░"
		tput cup 2 20 
		echo -e "░░$_RESET░░░"
		tput cup 3 20
		echo -e "░░$_EXIT░░"
		echo
	
		# also show color
		[ "$_PALAVRA" == "$_NEW" ] && _FORCA=$_VENCE && _FASE="6";
		echo -ne "\033[2K \033[G\033[34;1m$_FORCA\033[m";
		echo -e "\033[99;1m\n\n░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░$_TITULO░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░\n\n\033[m";
	
		# could use tput, but I used nail spaces and a condition to display the string after typing the 1st letter
		[[ $_NEW ]] && echo "                "$_NEW | tr [a-z] [A-Z] | sed 's/[A-Z]/ & /g;s/_/ & /g' || echo "                "$_LINHA | sed 's/_/ & /g'
	
		# take the letter you typed
		read -p " " -sn 1 _X;
	
		# Listen to what was typed and process
		# If the player presses CTRL + E
		if [ "$_X" == "" ]; then
			setterm -cursor on;
			reset;
			break;
			exit 0;
		# If the player presses CTRL + A
		elif [ "$_X" == "" ]; then	
			setterm -cursor on;
			break ;
		# If the player presses the directional keys, it picks up the letter of the key and treats like attempt
		# FIXME the right thing was to do nothing
		elif [ $(echo $_X | egrep -v "[a-z]") ]; then
			_X=$(echo $_X | tr  -d '\\ /][^[A-Z] [a-z]');
			continue;
		fi
	
		# find the letter you typed in the word
		if [[ $(echo $_PALAVRA | egrep "$_X" ) ]]; then
		 	
		 	tput cup 0 0;
		 	exibir_caracter_correto $_X;
		 	continue
		 	
	 	# if there is no letter in the word, enter this block
	 	else
	 		
	 		# creates the head
	 		if [ "$_FASE" == "" ]; then
	 			
	 			tput cup 0 0; 			
		 		_FORCA=$_CABECA;
		 		export _FASE="1";
		 		continue;
		 	# creates the neck
	 		elif [ "$_FASE" == "1" ]; then
	 			
	 			tput cup 0 0; 			
		 		_FORCA=$_PESCOCO;
		 		export _FASE="2";
		 		continue;
		 	# creates the body
	 		elif [ "$_FASE" == "2" ]; then
	 			
	 			tput cup 0 0; 			
		 		_FORCA=$_CORPO;
		 		export _FASE="3";
		 		continue;
		 	# creates the legs
	 		elif [ "$_FASE" == "3" ]; then
	 			
	 			tput cup 0 0; 			
		 		_FORCA=$_PERNA;
		 		export _FASE="4";
		 		continue;
		 		
		 	# game over
	 		elif [ "$_FASE" == "4" ]; then
	 			
	 			tput cup 0 0;
	 			export _RESET="\033[40;37;1m${_lang[13]}: [Ctrl + E]\033[m"
	 			export _EXIT="░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
	 			export _TITULO=" ${_lang[15]}: $_PALAVRA ";
		 		export _FORCA=$_ENFORCA;
		 		export _FASE="5";
		 		export _PALAVRA=" ";
		 		tput cup 28 0
		 		
		 		continue;
		 	
		 	# addresses the error, if any
	 		else
	 			tput cup 28 0
	 			break;
		 		exit 1
	 		fi
	 		
		fi
	
	done

	# restart the cursor
	setterm -cursor on

	# leave the game
	exit 0
