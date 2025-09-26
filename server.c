/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jenlee <jenlee@student.42kl.edu.my>        +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/07 15:28:24 by jenlee            #+#    #+#             */
/*   Updated: 2025/09/07 20:16:58 by jenlee           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft/libft.h"
#include <signal.h>

void	signals(int signal, siginfo_t *info, void *context)
{
	static unsigned char	current;
	static int				bit_index;

	(void)context;
	current <<= 1;
	if (signal == SIGUSR1)
		current |= 1;
	bit_index++;
	if (bit_index == 8)
	{
		if (current == '\0')
			ft_putchar_fd('\n', 1);
		else
			ft_putchar_fd(current, 1);
		bit_index = 0;
		current = 0;
	}
	kill(info->si_pid, SIGUSR1);
}

int	main(void)
{
	struct sigaction	sa;

	sa.sa_sigaction = signals;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = SA_SIGINFO;
	sigaction(SIGUSR1, &sa, 0);
	sigaction(SIGUSR2, &sa, 0);
	ft_putstr_fd("Server Pid:", 1);
	ft_putnbr_fd(getpid(), 1);
	ft_putchar_fd('\n', 1);
	while (1)
		pause();
	return (0);
}
