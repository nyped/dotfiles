#!/bin/bash
#
# get emojis (or strings) easily with rofi dmenu

in=$((cat <<EOF
alien
alpha
and
angel
apple
bug
calendar
car
clown
cold
definition
delta
down
dumb
epsilon
equivalent
exists
exists!
eyes
false
forall
gasy
genius
heart
implies
in
incognito
kali
lambda
lol
modulo
monkey
mu
muscle
nahhh
nose
not
note
noteq
notin
or
police
qed
robot
rock
sad
shook
shookcat
sigma
strong
swim
tautology
this
true
wave
EOF
) | rofi -dmenu -i -p Find: -lines 5 -columns 3)

case "$in" in
	"")
		exit 0
		;;

	clown)
		ret=🤡
		;;

	shook)
		ret=😱
		;;

	lol)
		ret=😆
		;;

	cold)
		ret=🥶
		;;

	sad)
		ret=😥
		;;

	alien)
		ret=👽
		;;

	robot)
		ret=🤖
		;;

	shookcat)
		ret=🙀
		;;

	rock)
		ret=🤘
		;;

	eyes)
		ret=👀
		;;

	strong | muscle)
		ret=💪
		;;

	police)
		ret=👮
		;;

	incognito)
		ret=🕵️
		;;

	genius)
		ret=🧞
		;;

	angel)
		ret=👼
		;;

	wave)
		ret=👋
		;;

	nose)
		ret=👃
		;;

	monkey)
		ret=🐒
		;;

	bug)
		ret=🪲
		;;

	dumb)
		ret=🦍
		;;

	kali)
		ret=🐉
		;;

	apple)
		ret=🍎
		;;

	swim)
		ret=🏊
		;;

	car)
		ret=🚙
		;;

	calendar)
		ret=🗓
		;;

	note)
		ret=📝
		;;

	heart)
		ret=❤️
		;;

	gasy)
		ret=🇲🇬
		;;

	nahhh)
		ret=🥲
		;;

	implies)
		ret=⇒
		;;

	equivalent)
		ret=⇔
		;;

	not)
		ret=¬
		;;

	and)
		ret=∧
		;;

	or)
		ret=∨
		;;

	true)
		ret=⊤
		;;

	false)
		ret=⊥
		;;

	exists)
		ret=∃
		;;

	exists!)
		ret=∃!
		;;

	forall)
		ret=∀
		;;

	modulo)
		ret=≡
		;;

	definition)
		ret=≔
		;;

	noteq)
		ret=≠
		;;

	tautology)
		ret=⊨
		;;

	delta)
		ret=δ
		;;

	epsilon)
		ret=Ɛ
		;;

	alpha)
		ret=α
		;;

	lambda)
		ret=λ
		;;

	mu)
		ret=μ
		;;

	sigma)
		ret=σ
		;;

	in)
		ret=∈
		;;

	notin)
		ret=∉
		;;

	qed)
		ret=□
		;;

	this)
		ret=↑
		;;

	down)
		ret=↓
		;;

	*)
		exit 0
		;;
esac

echo -n $ret | xclip -selection clipboard
xdotool key --window $(bspc query -N -n .local.focused) ctrl+v
