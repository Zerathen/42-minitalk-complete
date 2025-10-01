/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   client.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jenlee <jenlee@student.42kl.edu.my>        +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/07 15:43:11 by jenlee            #+#    #+#             */
/*   Updated: 2025/09/07 20:21:45 by jenlee           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft/libft.h"
#include <signal.h>
#include <unistd.h>

volatile sig_atomic_t	g_ack_received = 0;

void	handle_ack(int signal)
{
	(void)signal;
	g_ack_received = 1;
}

void	send_bit(int pid, int bit)
{
	if (bit)
		kill(pid, SIGUSR1);
	else
		kill(pid, SIGUSR2);
	while (!g_ack_received)
		usleep(1);
	g_ack_received = 0;
}

void	send(int pid, char c)
{
	int	i;
	int	bit;

	i = 8;
	while (i--)
	{
		bit = (c >> i) & 1;
		send_bit(pid, bit);
	}
}

int	check(int pid)
{
	if (kill(pid, 0) == -1)
	{
		ft_putstr_fd("Invalid PID or Server Not On\n", 2);
		return (-1);
	}
	return (1);
}

int	main(int argc, char *argv[])
{
	pid_t	serv_pid;
	char	*message;
	int		i;

	if (argc != 3)
	{
		ft_putstr_fd("Usage: ./client <PID> <MESSAGE>\n", 2);
		return (1);
	}
	signal(SIGUSR1, handle_ack);
	signal(SIGUSR2, handle_ack);
	serv_pid = ft_atoi(argv[1]);
	message = argv[2];
	i = 0;
	if (check(serv_pid) == -1)
		exit(0);
	while (message[i])
		send(serv_pid, message[i++]);
	send(serv_pid, '\0');
	return (0);
}
