
♡ Mensajitos ♡
Guía para levantar el proyecto

¡Buenas! ♡(.◜ω◝.)♡

Esta es una pequeña guía para configurar y levantar
los Mensajitos desde cero.

La idea es simple:

💌 Página web
      ↓
🤖 Bot de Telegram
      ↓
📱 Telegram
      ↓
💌 Página web

¡Importante!! la carpeta descargada debe estar en: C:\Telegram\ o se deberá modificar los códigos

════════════════════════════════════════
♡ 1. CREAR EL BOT DE TELEGRAM
════════════════════════════════════════

Primero, abrí Telegram y buscá:

@BotFather

Después: /start

y luego: /newbot

BotFather te va a pedir dos cosas:

♡ Nombre del bot
Elegí el nombre que quieras.

♡ Username
Tiene que terminar en "bot" o "_bot".

Ejemplo:

Nombre:   Roman G.
Username: RomanG_Bot

Cuando termines, BotFather te va a entregar un TOKEN.

Ejemplo de formato: 1234567890:AAExampleToken1234567890abcdef

⚠ IMPORTANTE:

El TOKEN es privado.
NO lo publiques en GitHub, redes sociales ni lo compartas
con otras personas.

El token del ejemplo es ficticio y no funciona.

════════════════════════════════════════
♡ 2. OBTENER EL CHAT ID
════════════════════════════════════════

Ahora necesitás obtener el Chat ID de la cuenta de
Telegram que va a recibir los mensajes.

Primero:

1. Abrí el bot que acabás de crear.
2. Mandale cualquier mensaje.

Por ejemplo:

Hola ♡

Después abrí tu navegador y escribí: https://api.telegram.org/botTU_TOKEN/getUpdates

Reemplazá TU_TOKEN por el token que te dio BotFather.

Ejemplo: https://api.telegram.org/bot1234567890:AAExampleToken1234567890abcdef/getUpdates

El navegador va a mostrar un texto en formato JSON.

Buscá una parte parecida a esta:

"chat": {
    "id": 123456789,
    "first_name": "Nombre"
}

El número que aparece junto a "id", dentro de "chat",
es el CHAT ID.

En este ejemplo: 123456789

♡ IMPORTANTE:

No confundas:

update_id
message_id
chat.id

El número que necesitamos es:

chat → id

════════════════════════════════════════
♡ 3. CONFIGURAR EL BACKEND
════════════════════════════════════════

La carpeta del proyecto debe estar ubicada en:

C:\Telegram

Dentro debería encontrarse algo parecido a:

C:\Telegram
│
├── backend.ps1
├── Abrir chat.bat
│
└── frontend
    └── index.html

Abrí:

backend.ps1

con el Bloc de notas. Buscá:

$telegramToken = "TU_TOKEN_NUEVO" (Fila 13)

Y reemplazá TU_TOKEN_NUEVO por el token de tu bot.

Después buscá:

$telegramChatId = "" (Fila 16)

Reemplazá ese número por el Chat ID que obtuviste
en el paso anterior.

Guardá el archivo.

════════════════════════════════════════
♡ 4. ABRIR LOS MENSAJITOS
════════════════════════════════════════

Volvé a:

C:\Telegram

Y hacé doble clic en:

Mensajear.bat

Esperá unos segundos.

El navegador debería abrir automáticamente:

http://127.0.0.1:8080/

Y aparecerá la página:

♡ Mensajitos ♡

════════════════════════════════════════
♡ FIN ♡
════════════════════════════════════════

