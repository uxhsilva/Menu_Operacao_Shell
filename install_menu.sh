#
# Script : ./install_menu.sh
# Feito  : Hertz S. [ hertz.raya@gmail.com ] [Versao 4.1-2016]
# Obs    : Script de instalacao do "Menu para Start de Jobs & Processos"
#          1 - Verifica se ha o usuario operacao criado no Sistema
#              com permissoes de root
#          2 - Acerta todas as variaveis do MENU de acordo com o Diretorio
#              HOME do usuario "operacao"
#          3 - Pede Informacoes para criacao do ambiente do Menu
#
#

if [ "$(id -u)" != "0" ]; then
echo
   echo -e "\nVoce deve executar este script como root!\n"
   exit 23
fi

  OPER_ALLOW="root"
   FILE_PACK="MENU_V4_R1_20170125.tar.gz"

   if [ -f "${FILE_PACK}" ]
   then
      echo instalando > /dev/null
   else
      echo -e "\n   Arquivo: $FILE_PACK Nao existe!\n"
      exit 23
   fi

tput clear

# Acerto do Comando echo -----------------------------------------------------

   if [ "`uname -s`" = "Linux" ]
   then
      ECHO()
      {
      echo -ne "$1"
      }
    else
      ECHO()
      {
      echo "$1"
      }
   fi

#------------------------------------------------------------------------------

 sp1=" "
 sp2="  "
 sp3="   "
 sp4="    "
 sp5="     "
 sp6="      "
 sp7="       "
 sp8="        "
 sp9="         "
sp10="          "
sp11="           "
sp12="            "
sp13="             "
sp14="              "
sp15="               "
sp16="                "
sp17="                 "
sp18="                  "
sp19="                   "
sp20="                    "
sp21="                     "
sp22="                      "
sp23="                       "
sp24="                        "
sp25="                         "
sp26="                          "

#------------------------------------------------------------------------------

input_operator()
{
   tput clear
   ECHO "\n\n      `tput smso`   Menu para Start de Jobs & Processos   `tput rmso`"

   read_operator()
   {
      tput cup 5 10
      echo "                                                                  "
      tput cup 5 10
      ECHO "Qual Login deseja para o Menu ? : ___________\b\b\b\b\b\b\b\b\b\b\b\c"
      read operator
      
      if [ "${operator}" = "" ]
      then
         tput cup 9 10
         echo "Login Invalido !  -  Tecle <RETURN> ...\c"
         read stop
         tput cup 9 10
         echo "                                                                        "
         read_operator
       else
         OPER_ALLOW="`echo ${operator}`"
      fi
   }

   first()
   {
   tput cup 5 10
   echo "O Login [DEFAULT] e' : `tput smso` ${OPER_ALLOW}  `tput rmso`"
   tput cup 7 10
   ECHO "Deseja mudar ? : (S/N) _\b\c"
   read confirma
  
case ${confirma} in
s|S) tput cup 7 10
     echo "                                                            "
     read_operator;;
n|N) echo "continue" > /dev/null ;;
*) tput cup 9 10
   ECHO "Opcao Invalida !   -  Tecle <RETURN> ...\c"
   read stop
   tput cup 9 10
   echo "                                                              "
   first;;
esac
   }
   
   first 
}

#------------------------------------------------------------------------------

conf_operacao()
{
   input_operator

   # operacao:x:0:0:Menu da Operacao:/home/operacao:/bin/bash
   # |        | | | |                |              |
   # |        | | | |                |              +--> [ 07 ] Shell
   # |        | | | |                +-----------------> [ 06 ] Diretorio HOME
   # |        | | | +----------------------------------> [ 05 ] Comentarios
   # |        | | +------------------------------------> [ 04 ] User  ID
   # |        | +--------------------------------------> [ 03 ] Group ID
   # |        +----------------------------------------> [ 02 ] Senha
   # +-------------------------------------------------> [ 01 ] Login

   cat /etc/passwd | grep ${OPER_ALLOW} | while read linha
   do
      USR="`echo ${linha} | cut -d\: -f1,1`"
      if [ "${USR}" = "${OPER_ALLOW}" ]
      then
         echo ${linha} > /tmp/oper.$$
      fi
   done
   
   if [ -f /tmp/oper.$$ ]
   then
      echo "${OPER_ALLOW} Existe" > /dev/null
       OGID="`cat /tmp/oper.$$ | cut -d\: -f 3,3`"
       OUID="`cat /tmp/oper.$$ | cut -d\: -f 4,4`"
      OHOME="`cat /tmp/oper.$$ | cut -d\: -f 6,6`"
      echo "${OHOME}" > /tmp/home.$$

         if [ "${OGID}" -eq 0 ]
         then
            echo "GID ok!" > /dev/mull
         else
            echo ""
            echo "   Grupo ID do Usuario \"${OPER_ALLOW}\" deve ser 0 (Zero) !"
            echo ""
            exit 23
         fi

         if [ "${OUID}" -eq 0 ]
         then
            echo "UID ok!" > /dev/mull
         else
            echo ""
            echo "   User  ID do Usuario \"${OPER_ALLOW}\" deve ser 0 (Zero) !"
            echo ""
            exit 23
         fi

         if [ -d ${OHOME} ]
         then
            echo "${OHOME} ok!" > /dev/mull
         else
            echo ""
            echo "   Diretorio : ${OHOME} Nao existe !"
            echo ""
            exit 23
         fi

      echo ""
      echo "   Login : ${OPER_ALLOW} - GID : ${OGID} - UID : ${OUID} --> [ `id -un` ] OK!"
      echo ""
      rm /tmp/oper.$$
   else
      echo ""
      echo "   Usuario : `tput smso` ${OPER_ALLOW} `tput rmso` Nao esta cadastrado !"
      echo ""
      exit 23
   fi
}

#------------------------------------------------------------------------------

   type openssl 1>/dev/null 2>/dev/null
   conf_openssl="$?"

   if [ ${conf_openssl} -eq 0 ]
   then
      echo existe openssl > /dev/null
      hash()
      {
      openssl dgst -sha1
      }
   else
      type cksum 1>/dev/null 2>/dev/null
      conf_cksum="$?"
   
         if [ ${conf_cksum} -eq 0 ]
         then
            echo existe cksum > /dev/null
            hash()
            {
            cksum | sed 's: ::g'
            }
         else
            echo ""
            echo "Nao existe : CKSUM ou OPENSSL instalado no Sistema !"
            echo ""
            exit 23
         fi
   fi

#------------------------------------------------------------------------------

stop_1()
{
   ECHO "\n\n                         Tecle <RETURN> para continuar ...\c"
   read stop
}

#------------------------------------------------------------------------------

install_pack()
{
   type gunzip 1>/dev/null 2>/dev/null
   conf_gunzip="$?"

   if [ "${conf_gunzip}" -gt 0 ]
   then
      echo ""
      echo "   Comando : `tput smso` gunzip `tput rmso` nao existe ou nao esta na variavel PATH !"
      echo ""
      exit 23
   fi

   gunzip ./${FILE_PACK}
   
   if [ "${?}" -gt 0 ]
   then
      echo ""
      echo "   Houve erro ao descompactar o arquivo : ./${FILE_PACK} "
      echo ""
      rm /tmp/home.$$ 2>/dev/null
      exit 23
   else
      echo "   ./${FILE_PACK} descompactado com Sucesso !"
   fi

   if [ -f /tmp/home.$$ ]
   then
      DIR_HOME="`cat /tmp/home.$$`"
      rm /tmp/home.$$
   else
      echo ""
      echo "   Arquivo : /tmp/home.$$ nao existe !"
      echo ""
      rm /tmp/home.$$ 2>/dev/null
      gzip ${LOCAL_DIR}/`echo ${FILE_PACK} | sed 's:\.gz::g'` 2>/dev/null
      exit 23
   fi

   cp ${LOCAL_DIR}/`echo ${FILE_PACK} | sed 's:\.gz::g'` ${DIR_HOME} 2>/dev/null

   if [ "${?}" -gt 0 ]
   then
      echo ""
      echo "   Erro [ CP ] no arquivo : ${LOCAL_DIR}/${FILE_PACK} para : ${DIR_HOME}"
      echo ""
      rm /tmp/home.$$ 2>/dev/null
      gzip ${LOCAL_DIR}/`echo ${FILE_PACK} | sed 's:\.gz::g'` 2>/dev/null
      exit 23
   else
      echo "   [ CP ] ./${FILE_PACK} ${DIR_HOME} OK!"
   fi

   cd ${DIR_HOME}
   tar xvf ./`echo ${FILE_PACK} | sed 's:\.gz::g'` 1>/dev/null 2>/dev/null
   rm ./`echo ${FILE_PACK} | sed 's:\.gz::g'`

   if [ "${?}" -gt 0 ]
   then
      echo ""
      echo "   Erro [ TAR ] no arquivo : ./${FILE_PACK} !"
      echo ""
      rm /tmp/home.$$ 2>/dev/null
      gzip ${LOCAL_DIR}/`echo ${FILE_PACK} | sed 's:\.gz::g'` 2>/dev/null
      exit 23
   else
      echo "   [ TAR ] ./${FILE_PACK} OK!"
      gzip ${LOCAL_DIR}/`echo ${FILE_PACK} | sed 's:\.gz::g'`
   fi

   # Palavra chave : DIRETORIOHOMEMENU para : .bash_profile e .profile

   if [ -f ${DIR_HOME}/.profile ]
   then
cat<<EOTF>/tmp/sh.$$
cat ${DIR_HOME}/.profile | sed 's:DIRETORIOHOMEMENU:${DIR_HOME}:g' > /tmp/pro.$$
EOTF
      chmod 777 /tmp/sh.$$
      bash /tmp/sh.$$

         if [ "${?}" -gt 0 ]
         then
            echo ""
            echo "   Erro [ CAT ] cat ${DIR_HOME}/.profile"
            echo ""
            gzip ${LOCAL_DIR}/`echo ${FILE_PACK} | sed 's:\.gz::g'` 2>/dev/null
            exit 23
         else
            echo "   [ CAT ] cat ${DIR_HOME}/.profile OK!"
         fi

      mv /tmp/pro.$$ ${DIR_HOME}/.profile

         if [ "${?}" -gt 0 ]
         then
            echo ""
            echo "   Erro [ MV ] mv /tmp/pro.$$ ${DIR_HOME}/.profile !"
            echo ""
            gzip ${LOCAL_DIR}/`echo ${FILE_PACK} | sed 's:\.gz::g'` 2>/dev/null
            exit 23
         else
            echo "   [ MV ] mv /tmp/pro.$$ ${DIR_HOME}/.profile OK!"
         fi
   else
      echo ""
      echo "   ${DIR_HOME}/.profile nao existe !"
      echo ""
      exit 23
   fi

   if [ -f ${DIR_HOME}/.bash_profile ]
   then
cat<<EOTF>/tmp/sh.$$
cat ${DIR_HOME}/.bash_profile | sed 's:DIRETORIOHOMEMENU:${DIR_HOME}:g' > /tmp/pro.$$
EOTF
      chmod 777 /tmp/sh.$$
      bash /tmp/sh.$$
      rm /tmp/sh.$$

         if [ "${?}" -gt 0 ]
         then
            echo ""
            echo "   Erro [ SED ] no arquivo : .bash_profile !"
            echo ""
            exit 23
         else
            echo "   [ CP ] .bash_profile OK!"
         fi

      mv /tmp/pro.$$ ${DIR_HOME}/.bash_profile

         if [ "${?}" -gt 0 ]
         then
            echo ""
            echo "   Erro [ MV ] no arquivo : /tmp/pro.$$ .bash_profile !"
            echo ""
            exit 23
         else
            echo "   [ MV ] /tmp/pro.$$ .bash_profile OK!"
         fi

   else
      echo ""
      echo "   ${DIR_HOME}/.bash_profile nao existe !"
      echo ""
      exit 23
   fi

   stop_1

}

#------------------------------------------------------------------------------

input_dados()
{
   tput clear
   ECHO "\n Dados para Configuracao : `tput smso` Menu para Start de Jobs & Processos `tput rmso`"

   input_logo()
   {
   tput cup 5 5
   echo "                                                            "
   tput cup 5 5
   ECHO "Entre com o nome da Empresa : ___________________________ \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\c"
   read logo
   
   count_logo="`echo ${logo} | wc -m`"
   count_logo="`echo ${count_logo}`"

   if [ "${logo}" = "" ]
   then
      tput cup 19 10
      ECHO "Campo Invalido !   -   Tecle <RETURN> ...\c"
      read stop
      tput cup 19 10
      echo "                                                             "
      input_logo
   else
      if [ "${count_logo}" -gt 28 ]
      then
         tput cup 19 10
         ECHO "Campo com mais de 27 Caracteres !   -   Tecle <RETURN> ...\c"
         read stop
         tput cup 19 10
         echo "                                                             "
         input_logo
       else
         count_logo="`expr ${count_logo} - 1`"
         echo "( 27 - ${count_logo} ) / 2" > /tmp/calc.$$
         div="`bc -l < /tmp/calc.$$ | cut -d \. -f1,1`"
         DIV="`bc -l < /tmp/calc.$$ | cut -d \. -f2,2 | cut -c 1-2`"
         rm /tmp/calc.$$

            if [ "${DIV}" -eq "00" ]
            then
               echo "SP1=\"\$sp`echo ${div}`\"" > /tmp/inc.$$
               echo "SP2=\"\$sp`echo ${div}`\"" >> /tmp/inc.$$
            else
               echo "SP1=\"\$sp`echo ${div}`\"" > /tmp/inc.$$
               echo "SP2=\"\$sp`echo ${div}`${sp1}\"" >> /tmp/inc.$$
            fi

         . /tmp/inc.$$
         rm /tmp/inc.$$
         logo="${SP1}${logo}${SP2}"
         tput cup 5 5
         echo "                                                            "
         tput cup 5 5
         ECHO "Entre com o nome da Empresa : [`tput smso`${logo}`tput rmso`]"
       fi 
   fi
   } 

   input_logo2()
   {
   tput cup 7 5
   echo "                                                             "
   tput cup 7 5
   ECHO "Entre com o nome curto da Empresa : _____________\b\b\b\b\b\b\b\b\b\b\b\b\b\c"
   read logo2
 
   count_logo2="`echo ${logo2} | wc -m`"
   count_logo2="`echo ${count_logo2}`"

   if [ "${logo2}" = "" ]
   then
      tput cup 19 10
      ECHO "Campo Invalido !   -   Tecle <RETURN> ...\c"
      read stop
      tput cup 19 10
      echo "                                                             "
      input_logo2
   else
      if [ "${count_logo2}" -gt 14 ]
      then
         tput cup 19 10
         ECHO "Campo com mais de 13 Caracteres !   -   Tecle <RETURN> ...\c"
         read stop
         tput cup 19 10
         echo "                                                             "
         input_logo2
       else
         count_logo2="`expr ${count_logo2} - 1`"
         echo "( 13 - ${count_logo2} ) / 2" > /tmp/calc.$$
         div="`bc -l < /tmp/calc.$$ | cut -d \. -f1,1`"
         DIV="`bc -l < /tmp/calc.$$ | cut -d \. -f2,2 | cut -c 1-2`"
         rm /tmp/calc.$$

            if [ "${DIV}" -eq "00" ]
            then
               echo "SP1=\"\$sp`echo ${div}`\"" > /tmp/inc.$$
               echo "SP2=\"\$sp`echo ${div}`\"" >> /tmp/inc.$$
            else
               echo "SP1=\"\$sp`echo ${div}`\"" > /tmp/inc.$$
               echo "SP2=\"\$sp`echo ${div}`${sp1}\"" >> /tmp/inc.$$
            fi

         . /tmp/inc.$$
         rm /tmp/inc.$$
         logo2="${SP1}${logo2}${SP2}"
         tput cup 7 5
         echo "                                                            "
         tput cup 7 5
         ECHO "Entre com o nome curto da Empresa : [`tput smso`${logo2}`tput rmso`]"
       fi 
   fi
   }

   input_dominio()
   {
   tput cup 9 5
   echo "                                                             "
   tput cup 9 5
   ECHO "Entre com o Dominio da Rede completo : ______________________________\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\c"
   read dominio

   if [ "${dominio}" = "" ]
   then
      tput cup 19 10
      ECHO "Campo Invalido !   -   Tecle <RETURN> ...\c"
      read stop
      tput cup 19 10
      echo "                                                             "
      input_dominio
    else
      conf_dominio="`echo ${dominio} | grep \\\. | wc -l`"
      conf_dominio="`echo ${conf_dominio}`"

         if [ "${conf_dominio}" -eq 0 ]
         then
            tput cup 19 10
            ECHO "Dominio Incorreto !  -  Tecle <RETURN> ...\c"
            read stop
            tput cup 19 10
            echo "                                                           "
            input_dominio
         fi
    fi
   }
   
   input_logo 
   input_logo2
   input_dominio
   stop_1
}

#------------------------------------------------------------------------------

alter_dados()
{
   echo ""
   change_file()
   {
      if [ -z "${1}" ]
      then
         tput cup 19 10
         ECHO "Sintaxe correta : change_file [ STRING ] [ STRING ] [ arquivo ] !"
         stop_1
         exit 23
      else
         if [ -z "${2}" ]
         then
            tput cup 19 10
            ECHO "Sintaxe correta : change_file [ STRING ] [ STRING ] [ arquivo ] !"
            stop_1
            exit 23
         fi
      fi
      
   # Palavras chaves :
   #
   #          LOGO_2="LOGODOISXXXXX"                +
   #            LOGO="LOGOLOGOLOGOLOGOLOGOLOGOLOG"  |
   #       OPER_NAME="OPERNAMEOPER"                 |--> .default_menu.inc
   #         DOMINIO="DOMINIOEMPRESA"               +
   #      
   #       OPER_NAME="OPERNAMEOPER"                 +
   #      OPER_ALLOW="OPERNAMEOPER"                 +--> MENOP001.sh
   #      

          STRING="${1}"
            FILE="${file_change}"

      if [ -f "${FILE}" ]
      then
         echo "cat ${FILE} | sed 's:${STRING}:${STRING_NEW}:g' > /tmp/sed.$$" >\
         /tmp/sh.$$
         echo "mv /tmp/sed.$$ ${FILE}" >> /tmp/sh.$$
         chmod 777 /tmp/sh.$$
         /tmp/sh.$$
            if [ "${?}" -eq 0 ]
            then
               echo "[ ${STRING_NEW} ] - ${FILE} - OK!"
               chmod 740 ${FILE} 2>/dev/null
               rm /tmp/sh.$$
            else
               echo "[ ${STRING_NEW} ] - ${FILE} - ERRO SED !"
               rm /tmp/sh.$$
               stop_1
            fi
      else
         tput cup 19 10
         ECHO "${FILE} nao existe !"
         stop_1
         exit 23
      fi
   }

   file_change="${DIR_HOME}/shell/.default_menu.inc"

   STRING_NEW="${logo}"
   change_file LOGOLOGOLOGOLOGOLOGOLOGOLOG ${STRING_NEW}

   STRING_NEW="${logo2}"
   change_file LOGODOISXXXXX               ${STRING_NEW}

   STRING_NEW="${OPER_ALLOW}"
   change_file OPERNAMEOPER                ${STRING_NEW}

   STRING_NEW="${dominio}"
   change_file DOMINIOEMPRESA              ${STRING_NEW}

   file_change="${DIR_HOME}/shell/MENOP001.sh"

   STRING_NEW="${OPER_ALLOW}"
   change_file OPERNAMEOPER                ${STRING_NEW}
 
   cp ${DIR_HOME}/shell/MENOP001.sh ${DIR_HOME}/shell/backup/MENOP001.sh
   stop_1
}

#------------------------------------------------------------------------------

clean_files()
{
   yes | /tmp/calc.* 2>/dev/null
   yes | /tmp/home.* 2>/dev/null
   yes | /tmp/inc.*  2>/dev/null
   yes | /tmp/oper.* 2>/dev/null
   yes | /tmp/pro.*  2>/dev/null
   yes | /tmp/sh.*   2>/dev/null
}

#------------------------------------------------------------------------------

ADD_USER()
{
   tput clear
   FILE_OPERATION="${DIR_HOME}/shell/operadores.inf"
   tput cup 2 10
   ECHO "[ ADICIONAR USUARIO AO MENU ]\n\n"

   read_new_user()
   {
         unset count_var
         unset carac_first
         unset CARAC_LAST_conf
         unset CARAC_LAST
         unset user_add
         unset count_senha
         unset new_user
         status=open

   tput cup 5 60
   echo "                            "
   tput cup 5 10
   ECHO "Entre com o Novo Login do Usuario ( oprxxx ou ADMxxx ) : ______\b\b\b\b\b\b\c"
   read new_user

   if [ ${status} = closed ]
   then
      echo continue > /dev/null
   else
      if [ "${new_user}" = "" ]
      then
         tput cup 15 10
         ECHO "Usuarios validos : oprxxx e ADMxxx !  Tecle < RETURN > ... \c"
         read stop
         tput cup 15 10
         ECHO "                                                                   "
         read_new_user
      else
         count_var="`echo ${new_user} | wc -m`" ; count_var="`echo ${count_var}`"
            if [ ${count_var} -eq 7 ]
            then
               echo OK > /dev/null
            else
               tput cup 15 10
               ECHO "Usuarios validos : oprxxx e ADMxxx !  Tecle < RETURN > ... \c"
               read stop
               tput cup 15 10
               ECHO "                                                                   "
               read_new_user
            fi
            CARAC_FIRST="`echo ${new_user} | cut -c1-3`"
             CARAC_LAST="`echo ${new_user} | cut -c4-6`"
            carac_first="`echo ${new_user} | cut -c1-3 | tr 'a-z' 'A-Z'`"

            if [ "$carac_first" = OPR ] ; then carac_first="`echo ${carac_first} | tr 'A-Z' 'a-z'`" ; fi

            if [ ${carac_first} = "ADM" ] || [ ${carac_first} = "opr" ]
            then
               echo "esta no padrao" > /dev/null
               if [ ${CARAC_FIRST} = adm ] 
               then
                  new_user="`echo ${new_user} | tr 'a-z' 'A-Z'`"
               fi
            else
               tput cup 15 10
               ECHO "Usuarios validos : oprxxx e ADMxxx !  Tecle < RETURN > ... \c"
               read stop
               tput cup 15 10
               ECHO "                                                               "
               read_new_user
            fi

            if [ ${CARAC_LAST} -gt 0 ] 2>/dev/null
            then
               echo ok > /dev/null
               unset CARAC_LAST
            else
               tput cup 15 10
               ECHO "Usuarios validos : oprxxx e ADMxxx !  Tecle < RETURN > ... \c"
               read stop
               tput cup 15 10
               ECHO "                                                               "
               read_new_user
            fi

      user_add=0

      cat ${FILE_OPERATION} | cut -d\: -f1,1 | grep "${new_user}" | while read user
      do
         case $user in
         ${new_user}) user_add="`expr $user_add + 1`"
         echo $user_add > /tmp/calc.$$ ;;
         esac
      done

      if [ -f /tmp/calc.$$ ]
      then
         user_add="`cat /tmp/calc.$$`" ; rm /tmp/calc.$$
      fi

      if [ "${user_add}" -gt 0 ]
      then
         tput cup 15 10
         ECHO "Usuario [ ${new_user} ] Ja esta cadastrado ! Tecle < RETURN > ... \c"
         read stop
         tput cup 15 10
         ECHO "                                                                  "
         read_new_user
      fi

         read_new_full_name

      fi
   fi
   }

   read_new_full_name()
   {
   tput cup 7 60
   echo "                            "
   tput cup 7 10
   ECHO "Entre com o Nome Completo do Usuario : \c"
   read new_full_name

      if [ "${new_full_name}" = "" ]
      then
         tput cup 15 10
         ECHO "Usuarios validos : oprxxx e ADMxxx !  Tecle < RETURN > ... \c"
         read stop
         tput cup 15 10
         ECHO "                                                                   "
         read_new_full_name
      else
         read_senha_1
      fi
   }

   read_senha_1()
   {
   tput cup 9 60
   echo "                            "
   tput cup 9 10
   ECHO "Digite a senha : \c"
   stty -echo
   read senha_1
   stty echo

      if [ "${senha_1}" = "" ]
      then
         tput cup 15 10
         ECHO "Senha em branco nao e' valida !       Tecle < RETURN > ... \c"
         read stop
         tput cup 15 10
         ECHO "                                                                   "
         read_senha_1
      else
         read_senha_2 
      fi
   }

   read_senha_2()
   {
   tput cup 11 60
   echo "                            "
   tput cup 11 10
   ECHO "Digite a senha :            ( Conferencia )\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\c"
   stty -echo
   read senha_2
   stty echo
   echo " "

      if [ "${senha_2}" = "" ]
      then
         tput cup 15 10
         ECHO "Senha em branco nao e' valida !       Tecle < RETURN > ... \c"
         read stop
         tput cup 15 10
         ECHO "                                                                   "
         read_senha_2
      else
         count_senha="`echo ${senha_2} | wc -m`"
         count_senha="`echo ${count_senha}`"
            if [ ${count_senha} -lt 7 ]
            then
               tput cup 15 10
               ECHO "A Senha deve ter no minimo 6 caracteres !   Tecle < RETURN > ... \c"
               read stop
               tput cup 15 10
               ECHO "                                                                     "
               read_senha_1
            else
                  if [ ${senha_1} = ${senha_2} ]
                  then
                     echo continue > /dev/null
                     add_user
                  else
                     tput cup 15 10
                     ECHO "A senha nao confere !   Tecle < RETURN > ... \c"
                     read stop
                     tput cup 15 10
                     echo "                                                                             "
                     read_senha_1
                   fi
            fi
      fi
   }

   add_user()
   {
   tput cup 15 10
   crypt="`echo ${senha_1} | hash`"
   ECHO "Criando usuario : ${new_user} - ${new_full_name} ...\c"

   if [ -f ${FILE_OPERATION} ]
   then
      echo "${new_user}:${crypt}:${new_full_name}" >> ${FILE_OPERATION}
      cat ${FILE_OPERATION} | sort > /tmp/sort.$$
      mv /tmp/sort.$$ ${FILE_OPERATION}
      chmod 400 ${FILE_OPERATION}
      unset crypt
      tput cup 17 10
      status=closed
      ECHO "Usuario Criado com Sucesso   -   Tecle <RETURN> ...\c"
      read stop
      echo ""
      make_log
    else
      tput cup 17 10
      echo "Arquivo : ${FILE_OPERATION} nao existe ! Script abortado !  -  Tecle <RETURN> ...\c"
      read stop
      exit 23
    fi
   }
   read_new_user
}

#------------------------------------------------------------------------------

make_log()
{
   tput clear
   ECHO "\n      `tput smso` Menu para Start de Jobs & Processos `tput rmso`\n"
   ECHO "\n      O menu esta pronto para utilizacao.\n"
   ECHO "\n      O Menu deve ser executado com o Login: `tput smso` ${OPER_ALLOW} `tput rmso`\n"
   ECHO "\n      Para entrar no Menu execute a seguinte linha de comando :\n"
   ECHO "\n      # ssh ${OPER_ALLOW}@localhost"
   ECHO "\n      ou"
   ECHO "\n      # telnet localhost\n"
   ECHO "\n      e logar-se como : [ ${OPER_ALLOW} ]\n"
   ECHO "\n      Logo apos ustilizar o Login do Menu : ${new_user}\n"
   ECHO "\n      Para maiores informacoes sobre o Menu veja o arquivo :\n"
   ECHO "\n      <<<< `tput smso` ${DIR_HOME}/doc/LEIA_ME.txt  `tput rmso` >>>>\n"
   stop_1

cat<<EOT>${DIR_HOME}/install.log

   No dia : `date +%d/%m/%Y` as `date +%H:%M:%S`
   Foi criado o :  Menu para Start de Jobs & Processos

   Sera executado no Login ( Unix ) : ${OPER_ALLOW}
   Foi criado o Login ( Menu )      : ${new_user}
   Login : ${new_full_name} [ ${new_user} ]
   O diretorio Home do Menu         : ${DIR_HOME}

EOT
}

#------------------------------------------------------------------------------

LOCAL_DIR="`pwd`"

  conf_root
  conf_operacao
  install_pack
  input_dados
  alter_dados
  clean_files
  ADD_USER
