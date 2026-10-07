# ♡ Mensajitos

Una pequeña aplicación web para mandar y recibir mensajes mediante Telegram, sin que la otra persona necesite tener Telegram instalado.

La idea nació de algo bastante simple:

**una persona escribe desde una página web y la otra responde desde Telegram.**

Y listo. Comunicación humana resuelta mediante PowerShell, JavaScript y una cantidad razonable de sufrimiento. (╥﹏╥)

---

## ｡･:*˚:✧｡ ¿Cómo funciona?

La comunicación funciona así:

**Página web → PowerShell → Bot de Telegram → Telegram**

Y para responder:

**Telegram → Bot de Telegram → PowerShell → Página web**

La persona que utiliza la página solamente necesita abrir el navegador.

La persona que responde utiliza Telegram normalmente.

(｡•̀ᴗ-)✧

---

## ♡ Características

* Chat web sencillo.
* Envío de mensajes a Telegram.
* Respuestas de Telegram visibles en la página web.
* Actualización automática de mensajes.
* Hora de cada mensaje.
* Diseño adaptable a celulares.
* Cuatro temas visuales.
* El tema elegido queda guardado en el navegador.
* `Enter` para enviar.
* `Shift + Enter` para escribir varias líneas.
* No necesita base de datos.
* No necesita Node.js.
* No necesita PHP.
* No necesita Apache.
* Solamente PowerShell, HTML, CSS y JavaScript.

(づ｡• ᵕ •｡)づ

---

## ✦ Tecnologías

El proyecto utiliza:

* **HTML** para la estructura.
* **CSS** para el diseño.
* **JavaScript** para el funcionamiento del chat.
* **PowerShell** para el servidor y la comunicación con Telegram.
* **Batch** para iniciar y cerrar el proyecto.
* **Telegram Bot API** para enviar y recibir mensajes.

---

## ♡ Estructura

```text
Telegram-sin-Telegram/
│
├── backend.ps1
├── Abrir mensajes.bat
├── cerrar.bat
├── README.md
│
└── frontend/
    └── index.html
```

Si se utilizan los `.bat` incluidos sin modificar, la carpeta principal debe encontrarse en:

`C:\Telegram`

Quedaría así:

`C:\Telegram\backend.ps1`

`C:\Telegram\Abrir mensajes.bat`

`C:\Telegram\cerrar.bat`

`C:\Telegram\frontend\index.html`

(｡• ᵕ •｡)

---

# ♡ Configuración

## 1. Crear el bot de Telegram

Primero hay que abrir Telegram y buscar:

`@BotFather`

Después:

`/start`

y:

`/newbot`

BotFather va a pedir:

* Nombre del bot.
* Username del bot.

El username tiene que terminar en `bot` o `_bot`.

Por ejemplo:

`RomanG_Bot`

Cuando termine la creación, BotFather va a entregar un **token**.

El token tiene un formato parecido a:

`1234567890:AAExampleToken1234567890abcdef`

Ese token es privado.

**No lo publiques en GitHub.**

El ejemplo anterior es ficticio y no funciona.

(；￣Д￣)

---

## 2. Obtener el Chat ID

Ahora hay que conseguir el Chat ID de la cuenta de Telegram que va a recibir los mensajes.

Primero:

1. Abrí el bot.
2. Mandale cualquier mensaje.

Por ejemplo:

`Hola (｡•́‿•̀｡)`

Después abrí en el navegador:

`https://api.telegram.org/botTU_TOKEN/getUpdates`

Reemplazá `TU_TOKEN` por el token real del bot.

Telegram va a devolver información en formato JSON.

Buscá algo parecido a:

```json
"chat": {
    "id": 123456789,
    "first_name": "Nombre"
}
```

El número que aparece en:

`chat → id`

es el **Chat ID** que necesitamos.

No hay que confundirlo con:

* `update_id`
* `message_id`
* `chat.id`

El importante es:

`chat.id`

(๑•̀ㅂ•́)و✧

---

# ♡ Configurar `backend.ps1`

Abrí:

`backend.ps1`

Buscá:

```powershell
$telegramToken = ""
```

y colocá el token:

```powershell
$telegramToken = "TU_TOKEN"
```

Después buscá:

```powershell
$telegramChatId = ""
```

y colocá el Chat ID:

```powershell
$telegramChatId = "123456789"
```

Guardá el archivo.

Y por favor, por el bien de la civilización, no subas el token real a GitHub. (╥﹏╥)

---

# ♡ Abrir Mensajitos

Una vez configurado todo, ejecutá:

`Abrir mensajes.bat`

El backend se iniciará automáticamente y el navegador debería abrir:

`http://127.0.0.1:8080/`

Y aparecerá:

**♡ Mensajitos ♡**

(っ´ω`)ﾉ(╥ω╥)

---

# ✦ ¿Qué pasa cuando se manda un mensaje?

Cuando alguien escribe desde la página:

**Página web**

↓

**`/send`**

↓

**PowerShell**

↓

**Telegram Bot API**

↓

**Telegram**

El mensaje llega directamente a la cuenta configurada.

Cuando la persona responde desde Telegram:

**Telegram**

↓

**Telegram Bot API**

↓

**PowerShell**

↓

**`/messages`**

↓

**Página web**

Así la conversación aparece en ambos lados.

(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧

---

# ♡ Temas

Mensajitos tiene cuatro temas:

### Gris

El tema normal y neutral.

Ideal para fingir que esto es una aplicación empresarial seria.

(￣▽￣)

### Dark

Un tema oscuro para quienes aparentemente necesitan que todo lo que usan parezca una terminal de servidor.

(¬‿¬)

### Cute

Colores pastel, rosados y violetas.

(｡・ω・｡) ♡

### Universo

Un tema oscuro inspirado en el espacio.

✦ ˚ .
　✧
　　　.
✦　　　˚
　　✧

La selección se guarda en el navegador mediante `localStorage`.

---

# ♡ Historial

Actualmente los mensajes se guardan solamente mientras `backend.ps1` está funcionando.

Eso significa que si el backend se cierra:

* El historial de la página desaparece.
* Los mensajes que ya fueron enviados siguen estando en Telegram.
* Al volver a abrir el proyecto, el chat web comienza nuevamente vacío.

Todavía no hay una base de datos.

Es intencionalmente simple.

( ˘ω˘ )

---

# ♡ Cerrar el proyecto

Para cerrar el proyecto se puede utilizar:

`cerrar.bat`

Actualmente el archivo detiene los procesos de PowerShell.

Por eso, si tenés otros procesos de PowerShell funcionando, conviene tener cuidado.

Esto puede mejorarse en futuras versiones para que solamente cierre el backend de Mensajitos.

(；・∀・)

---

# ♡ Seguridad

El servidor utiliza:

`127.0.0.1:8080`

Eso significa que, por defecto, solamente está disponible desde la computadora donde se ejecuta.

El proyecto no está pensado para exponerse directamente a Internet.

Nunca publiques:

* El token del bot.
* Contraseñas.
* Credenciales.
* Configuraciones privadas.
* Información personal innecesaria.

Si un token se publica accidentalmente, hay que revocarlo y generar uno nuevo desde `@BotFather`.

(ノಠ益ಠ)ノ彡┻━┻

---

# ✧ Cosas que todavía se pueden mejorar

Algunas ideas para futuras versiones:

* Guardar el historial permanentemente.
* Usar SQLite.
* Mostrar fecha completa además de la hora.
* Mejorar el cierre del backend.
* Agregar indicador de conexión.
* Agregar notificaciones.
* Agregar sonidos.
* Permitir imágenes.
* Agregar más temas.
* Separar la configuración privada del código.
* Crear un instalador.
* Agregar autenticación si algún día se utiliza fuera de la computadora local.

Hay trabajo para rato, porque aparentemente una página para mandar “hola ma” necesita arquitectura evolutiva. (´-ω-`)

---

# ♡ Sobre el proyecto

**Mensajitos** fue creado como un proyecto pequeño y personal para resolver una situación muy concreta:

> Permitir que una persona que no utiliza Telegram pueda comunicarse con alguien que sí lo utiliza desde una página web.

La idea es mantenerlo simple, liviano y fácil de entender.

No intenta ser una plataforma de mensajería completa.

Es simplemente un pequeño puente entre una página web y Telegram.

(｡• ᵕ •｡)♡

---

# ♡ Hecho con

HTML
CSS
JavaScript
PowerShell
Telegram Bot API

y probablemente demasiado cariño para algo que básicamente manda mensajes. (つ≧▽≦)つ♡

---
